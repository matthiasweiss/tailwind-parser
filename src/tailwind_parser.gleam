import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  io.println(string.join(extract_class_names("\"one\" asd \"two\""), ", "))
}

pub fn extract_class_names(input: String) -> List(String) {
  string.split(input, "")
  |> extract_class_names_recursive([], "", "")
}

fn extract_class_names_recursive(
  input: List(String),
  accumulator: List(String),
  current_word: String,
  current_delimiter: String,
) -> List(String) {
  case input {
    [next_element, ..rest] -> {
      case current_delimiter {
        "" -> {
          extract_class_names_empty_delimiter(
            next_element,
            rest,
            accumulator,
            current_word,
          )
        }
        _ -> {
          extract_class_names_nonempty_delimiter(
            next_element,
            rest,
            accumulator,
            current_word,
            current_delimiter,
          )
        }
      }
    }
    _ -> accumulator
  }
}

fn extract_class_names_empty_delimiter(
  next_element: String,
  rest: List(String),
  accumulator: List(String),
  current_word: String,
) {
  case next_element {
    "\"" | "'" | "`" -> {
      extract_class_names_recursive(
        rest,
        accumulator,
        current_word,
        next_element,
      )
    }
    _ -> {
      extract_class_names_recursive(rest, accumulator, current_word, "")
    }
  }
}

fn extract_class_names_nonempty_delimiter(
  next_element: String,
  rest: List(String),
  accumulator: List(String),
  current_word: String,
  current_delimiter: String,
) {
  case next_element == current_delimiter {
    True -> {
      let new_accumulator = list.append(accumulator, [current_word])
      extract_class_names_recursive(rest, new_accumulator, "", "")
    }
    False -> {
      case next_element {
        " " | "\n" -> {
          case current_word {
            "" -> {
              extract_class_names_recursive(
                rest,
                accumulator,
                "",
                current_delimiter,
              )
            }
            _ -> {
              let new_accumulator = list.append(accumulator, [current_word])
              extract_class_names_recursive(
                rest,
                new_accumulator,
                "",
                current_delimiter,
              )
            }
          }
        }
        _ -> {
          extract_class_names_recursive(
            rest,
            accumulator,
            current_word <> next_element,
            current_delimiter,
          )
        }
      }
    }
  }
}
