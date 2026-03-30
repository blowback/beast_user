# _plugins/rouge_z80_sjasmplus.rb
#
# A Rouge lexer for Z80 assembly language, sjasmplus dialect.
#
# Place this file in Jekyll _plugins/ directory. Because GitHub Pages
# runs Jekyll in safe mode (no plugins), you must build with GitHub Actions
# and push the generated HTML to gh-pages yourself.
#
# Usage in Markdown:
#   ```sjasmplus
#   LD A, 42
#   CALL print_hex
#   ```
#
# You can also use the alias `z80` if you prefer:
#   ```z80
#   ...
#   ```

module Rouge
  module Lexers
    class SjASMPlus < RegexLexer
      tag 'sjasmplus'
      aliases 'z80', 'z80asm'
      filenames '*.asm', '*.z80', '*.s'
      mimetypes 'text/x-z80asm'

      title "Z80 Assembly (sjasmplus)"
      desc "Z80 assembly language, sjasmplus dialect (https://github.com/z00m128/sjasmplus)"

      # -----------------------------------------------------------------------
      # Token helpers
      # -----------------------------------------------------------------------

      # All Z80 / Z80N / R800 / i8080 / GB mnemonics (documented + undocumented)
      MNEMONICS = %w[
        ADC ADD AND BIT CALL CCF CP CPD CPDR CPI CPIR CPL DAA DEC DI DJNZ EI
        EX EXX HALT IM IN INC IND INDR INI INIR JP JR LD LDD LDDR LDI LDIR
        NEG NOP OR OTDR OTIR OUT OUTD OUTI POP PUSH RES RET RETI RETN RL RLA
        RLC RLCA RLD RR RRA RRC RRCA RRD RST SBC SCF SET SLA SLL SRA SRL SUB
        XOR
        MULUB MULUW                   # R800
        SWAP                          # GB/LR35902
        LDIX LDIRX LDDX LDDRX LDPIRX LDIRSCALE
        OUTINB SWAPNIB BSLA BSRA BSRL BSRF BRLC
        MIRROR NEXTREG PIXELAD PIXELDN SETAE
        ADD16 ADD8 SUB8
        TEST
      ].freeze

      # Z80 registers (8-bit, 16-bit, index, special, flags)
      REGISTERS = %w[
        A B C D E H L F
        AF BC DE HL SP PC
        IX IY IXH IXL IYH IYL
        I R
        AF'
      ].freeze

      # Condition codes
      CONDITIONS = %w[NZ Z NC C PO PE P M].freeze

      # sjasmplus pseudo-ops / directives
      DIRECTIVES = %w[
        ALIGN ASSERT
        BINARY BLOCK BPLIST BUILDSYM BYTE
        CSPECTMAP
        DB DC DD DS DUP DW DWORD
        EDUP ELSE ELSEIF END ENDIF ENDLUA ENDM ENDMAP ENDMODULE ENDS ENT EQU
        ERROR ENCODING
        FIELD
        HEX
        IF IFDEF IFNDEF IFUSED IFNUSED INCBIN INCLUDE INCHOB INCTRD
        LUA LABELSLIST
        MACRO MAP MEMORYMAP MESSAGE MODULE
        ORG OPT OUTPUT
        PAGE PROC
        REPT
        SAVE SAVEHOB SAVESNA SAVETAP SAVEBIN SAVENEX SAVETRD SAVECDT SAVEIMG
        SAVEDEV
        SET SETBP SETBREAKPOINT SIZE SHELLEXEC SLOT STRUCT
        TAPOUT TAPEND TEXTAREA
        UNDEFINE
        WHILE WORD
        DEVICE DISP DISPLAY
        DEFINE DEFB DEFW DEFD DEFS DEFM DEFG DEFN
        ALIGN16
      ].freeze

      # sjasmplus built-in functions / expression operators (word-like)
      BUILTINS = %w[
        DEFINED EXIST HIGH LOW NOT PAGE SLOT
        INT FLOAT ABS CEIL FLOOR ROUND SQRT
        STRLEN STRLWR STRUPR
      ].freeze

      # sjasmplus predefined symbols
      PREDEFINED = %w[
        _SJASMPLUS __SJASMPLUS__
        _VERSION __VERSION__
        _RELEASE __RELEASE__
        _ERRORS __ERRORS__
        _WARNINGS __WARNINGS__
        _PASS __PASS__
        __FILE__ __LINE__ __COUNTER__
      ].freeze

      # -----------------------------------------------------------------------
      # Helper regexes (not states themselves, just named fragments)
      # -----------------------------------------------------------------------

      # Case-insensitive word boundary matching
      def self.keywords(list)
        /\b(?:#{list.map { |w| Regexp.escape(w) }.join('|')})\b/i
      end

      MNEMONIC_RE   = keywords(MNEMONICS)
      REGISTER_RE   = /\b(?:#{REGISTERS.map { |r| Regexp.escape(r) }.join('|')})\b/i
      CONDITION_RE  = /\b(?:#{CONDITIONS.join('|')})\b/i
      DIRECTIVE_RE  = keywords(DIRECTIVES)
      BUILTIN_RE    = keywords(BUILTINS)
      PREDEF_RE     = /\b(?:#{PREDEFINED.map { |p| Regexp.escape(p) }.join('|')})\b/

      # -----------------------------------------------------------------------
      # States
      # -----------------------------------------------------------------------

      state :root do
        # Blank lines / whitespace
        rule(/\s+/, Text::Whitespace)

        # Single-line comments: ; ...
        rule(/;.*$/, Comment::Single)

        # Multiline block comments: /* ... */ (sjasmplus extension)
        rule(%r{/\*}, Comment::Multiline, :block_comment)

        # C-style single-line // comment (sjasmplus also accepts these)
        rule(%r{//.*$}, Comment::Single)

        # String literals: double-quoted (escape sequences supported)
        rule(/"(?:[^"\\]|\\.)*"/, Str::Double)

        # String literals: single-quoted character literal
        rule(/'(?:[^'\\]|\\.)*'/, Str::Single)

        # sjasmplus module-qualified label reference or definition, e.g.
        #   modulename.labelname or @globallabel
        rule(/@[A-Za-z_][A-Za-z0-9_.]*/, Name::Label)

        # Temporary / numeric labels: 1F 2B etc (used in JR 1F, DJNZ 2B)
        rule(/\b[0-9]+[FfBb]\b/, Name::Label)

        # Label definitions: identifiers at start of line, optionally ending
        # with one or two colons (sjasmplus allows label::)
        rule(/^[A-Za-z_.][A-Za-z0-9_.]*:{1,2}/, Name::Label)

        # Numeric local labels at start of line (e.g. "1  LD A,B")
        rule(/^[0-9]+(?=\s)/, Name::Label)

        # Directives (must come before general identifier matching)
        rule(DIRECTIVE_RE, Keyword::Declaration)

        # Built-in expression functions
        rule(BUILTIN_RE, Name::Builtin)

        # Predefined symbols (__LINE__, _SJASMPLUS, etc.)
        rule(PREDEF_RE, Name::Constant)

        # Z80 mnemonics
        rule(MNEMONIC_RE, Keyword)

        # Registers — matched after mnemonics so e.g. "HALT" doesn't eat "H"
        rule(REGISTER_RE, Name::Builtin::Pseudo)

        # If \b doesn't match the apostrophe in `AF'` add this:
        # rule(/\bAF'/i, Name__Builtin::Pseudo)

        # Condition codes  (NZ, Z, NC, C, PO, PE, P, M)
        rule(CONDITION_RE, Keyword::Type)

        # Hexadecimal literals:  0xDEAD  $DEAD  #DEAD  0DEADh / 0deadH
        rule(/0x[0-9A-Fa-f]+/, Num::Hex)
        rule(/\$[0-9A-Fa-f]+/, Num::Hex)
        rule(/#[0-9A-Fa-f]+/, Num::Hex)
        rule(/[0-9][0-9A-Fa-f]*[hH]\b/, Num::Hex)

        # Binary literals: 0b1010  %1010  1010b / 1010B
        rule(/0b[01]+/, Num::Bin)
        rule(/%[01]+/, Num::Bin)
        rule(/[01]+[bB]\b/, Num::Bin)

        # Octal literals: 0q17  17q / 17o
        rule(/0q[0-7]+/, Num::Oct)
        rule(/[0-7]+[qQoO]\b/, Num::Oct)

        # Decimal literals
        rule(/[0-9]+[dD]?\b/, Num::Integer)

        # Current-address symbol $  (must come after hex $ prefix above)
        rule(/\$(?![0-9A-Fa-f])/, Name::Constant)

        # sjasmplus operators and punctuation
        rule(/[+\-*\/\\|&^~<>!%=?]/, Operator)
        rule(/[()\[\],.:@]/, Punctuation)

        # General identifiers (labels referenced as operands, macro names, etc.)
        rule(/[A-Za-z_.][A-Za-z0-9_.]*/, Name)

        # Anything else: pass through as plain text rather than erroring
        rule(/./, Text)
      end

      state :block_comment do
        rule(%r{\*/}, Comment::Multiline, :pop!)
        rule(%r{[^*]+}, Comment::Multiline)
        rule(%r{\*(?!\/)}, Comment::Multiline)
      end
    end
  end
end
