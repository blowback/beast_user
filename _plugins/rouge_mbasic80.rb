# _plugins/rouge_mbasic80.rb
#
# A Rouge lexer for Microsoft BASIC-80 (MBASIC), CP/M version 5.x.
#
# Place this file in your Jekyll _plugins/ directory alongside
# rouge_z80_sjasmplus.rb. Requires a GitHub Actions build workflow
# (GitHub Pages safe mode does not allow custom plugins).
#
# Usage in Markdown:
#   ```mbasic
#   10 REM Hello World
#   20 PRINT "Hello, World!"
#   30 END
#   ```
#
# Aliases: mbasic80, basic80

require 'rouge'

module Rouge
  module Lexers
    class MBasic80 < RegexLexer
      tag 'mbasic'
      aliases 'mbasic80', 'basic80'
      filenames '*.bas', '*.BAS'
      mimetypes 'text/x-mbasic'

      title "MBASIC-80"
      desc "Microsoft BASIC-80 for CP/M (MBASIC v5.x)"

      # -----------------------------------------------------------------------
      # Keyword lists
      # -----------------------------------------------------------------------

      # Statements and commands — things that appear as the verb of a line
      STATEMENTS = %w[
        AUTO
        CALL CHAIN CLEAR CLOSE COMMON CONT
        DATA DEFDBL DEFINT DEFSNG DEFSTR DELETE DIM
        EDIT END ERASE ERROR
        FIELD FILES FOR
        GET GOSUB GOTO
        IF INPUT INPUT# 
        KILL
        LET LINE LLIST LOAD LPRINT LSET
        MERGE
        NAME NEW NEXT NULL
        ON OPEN OPTION
        POKE PRINT PRINT#
        READ REM RENAME RENUM RESET RESTORE RESUME RETURN RUN
        SAVE SET STOP SWAP SYSTEM
        TROFF TRON
        WAIT WHILE WEND WRITE WRITE#
      ].freeze

      # Functions — appear in expressions, return a value
      FUNCTIONS = %w[
        ABS ASC ATN
        CDBL CHR$ CINT COS CSNG CVD CVI CVS
        EOF ERL ERR EXP
        FIX FRE
        HEX$
        INP INPUT$ INSTR INT
        LEFT$ LEN LOC LOF LOG LPOS
        MID$ MKD$ MKI$ MKS$
        OCT$
        PEEK POS
        RIGHT$ RND
        SGN SIN SPC SQR STR$ STRING$
        TAB TAN
        USR
        VAL VARPTR
      ].freeze

      # Operators that are words rather than symbols
      WORD_OPERATORS = %w[
        AND EQV IMP MOD NOT OR XOR
      ].freeze

      # Flow-control / structural keywords that aren't quite statements
      # on their own: THEN, ELSE, TO, STEP, AS, BASE
      KEYWORDS = %w[
        AS BASE ELSE STEP THEN TO
      ].freeze

      # Type-declaration / definition keywords
      TYPE_KEYWORDS = %w[
        DEFFN FN
      ].freeze

      # -----------------------------------------------------------------------
      # Helpers
      # -----------------------------------------------------------------------

      def self.keywords(list)
        /(?:#{list.map { |w| Regexp.escape(w) }.join('|')})/i
      end

      STATEMENT_RE     = keywords(STATEMENTS)
      FUNCTION_RE      = keywords(FUNCTIONS)
      WORD_OP_RE       = keywords(WORD_OPERATORS)
      KEYWORD_RE       = keywords(KEYWORDS)
      TYPE_KEYWORD_RE  = keywords(TYPE_KEYWORDS)

      # -----------------------------------------------------------------------
      # States
      # -----------------------------------------------------------------------

      state :root do
        # Whitespace
        rule(/\s+/, Text::Whitespace)

        # Line numbers at the start of a line (optional in direct mode)
        rule(/^\d+/, Num::Integer, :after_linenum)

        # REM comment — must be matched as a statement then consume rest of line.
        # Handled in :after_linenum and :statement via push to :remark.
        # Also handle bare REM at the very start (direct mode / no line number).
        rule(/\bREM\b.*/i, Comment::Single)

        # Everything else falls through to :statement
        rule(/(?=.)/, Text, :statement)
      end

      state :after_linenum do
        rule(/[ \t]+/, Text::Whitespace)

        # REM after a line number
        rule(/\bREM\b.*/i, Comment::Single, :pop!)

        # Otherwise hand off to statement lexing
        rule(/(?=.)/, Text, :statement)
      end

      state :statement do
        rule(/\n/, Text::Whitespace, :pop!)

        rule(/[ \t]+/, Text::Whitespace)

        # Statement separator (colon)
        rule(/:/, Punctuation)

        # REM after a colon / inline
        rule(/\bREM\b.*/i, Comment::Single)

        # String literals
        rule(/"[^"\n]*"?/, Str::Double)

        # DATA statement values (unquoted strings after DATA keyword handled
        # by matching DATA specially, then the rest of the items as string
        # literals — simplest approach is to tokenise the items as generic text
        # since they're comma-separated barewords)

        # Functions (match before statements to catch e.g. INPUT$, MID$ etc.)
        rule(/(#{FUNCTION_RE.source})(?=\s*[\$(])/, Name::Builtin)
        rule(FUNCTION_RE, Name::Builtin)

        # Type-declaration keywords (DEFFN, FN)
        rule(TYPE_KEYWORD_RE, Keyword::Declaration)

        # Main statement keywords
        rule(STATEMENT_RE, Keyword)

        # Structural / flow keywords
        rule(KEYWORD_RE, Keyword)

        # Word operators
        rule(WORD_OP_RE, Operator::Word)

        # Numeric literals
        # Double-precision: trailing #
        rule(/[0-9]*\.[0-9]+(?:[Ee][+-]?[0-9]+)?#?/, Num::Float)
        rule(/[0-9]+(?:[Ee][+-]?[0-9]+)?#/, Num::Float)
        # Hex: &H prefix
        rule(/&H[0-9A-Fa-f]+%?/, Num::Hex)
        # Octal: &O prefix (or bare & followed by octal digits)
        rule(/&O?[0-7]+%?/, Num::Oct)
        # Plain integer (with optional % type suffix)
        rule(/[0-9]+%?/, Num::Integer)

        # File number: #1, #2 etc.
        rule(/#\d+/, Name::Variable)

        # Variable names:
        #   - string variables end with $
        #   - integer variables end with %
        #   - double-precision end with #
        #   - single-precision end with !
        #   - plain (single-precision default) — no suffix
        # MBASIC-80 v5.x allows up to 40-char variable names.
        rule(/[A-Za-z][A-Za-z0-9]*[$%#!]?/, Name::Variable)

        # Arithmetic and comparison operators
        rule(/[+\-*\/^\\]/, Operator)
        rule(/[<>=]/, Operator)

        # Punctuation: parentheses, comma, semicolon
        rule(/[(),;]/, Punctuation)

        # Anything else — pass through rather than error
        rule(/./, Text)
      end
    end
  end
end
