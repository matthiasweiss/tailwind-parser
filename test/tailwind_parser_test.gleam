import gleeunit
import gleeunit/should
import tailwind_parser.{extract_class_names}

pub fn main() {
  gleeunit.main()
}

pub fn extract_class_names_test() {
  let input =
    "let x = \"double_quote1\";

    let y = \"double_quote2
      double_quote3
    double_quote4\"

    let x = 'single_quote1';

    let y = 'single_quote2
      single_quote3
    single_quote4'

    let x = `backtick1`;

    let y = `backtick2
     backtick3
    backtick4`
    "

  let expected_classes = [
    "double_quote1", "double_quote2", "double_quote3", "double_quote4",
    "single_quote1", "single_quote2", "single_quote3", "single_quote4",
    "backtick1", "backtick2", "backtick3", "backtick4",
  ]
  extract_class_names(input) |> should.equal(expected_classes)
}
