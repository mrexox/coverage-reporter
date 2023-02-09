require "../file_report"

module CoverageReporter
  # Parser interface.
  #
  # To add a new parser create a class in parsers/ folder and implement these
  # methods. For example, if you add a mycov parser, the code should look like this:
  # ```
  # require "./base_parser"
  #
  # module CoverageReporter
  #   class MycovParser < BaseParser
  #     def globs
  #       ["**/*/*.mycov"]
  #     end
  #
  #     def matches?(filename)
  #       filename.ends_with?(".mycov")
  #     end
  #
  #     def parse(filename)
  #       # ... mycov format specific parsing
  #     end
  #   end
  # end
  # ```
  # Them add your parser class to `PARSERS` tuple in `Parser` class.
  # ```
  # PARSERS = {
  #   # ...
  #   MycovParser.new,
  # }
  # ```
  #
  # Existing parsers can be used as a reference.
  abstract class BaseParser
    # Returns an array of globs that will be used to look for coverage reports.
    abstract def globs : Array(String)

    # Checks if the file can be parsed with the parser.
    abstract def matches?(filename : String) : Bool

    # Parses the file and returns an array of `FileReport` which will be
    # sent to Coveralls API.
    abstract def parse(filename : String) : Array(FileReport)
  end
end
