import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  io.println(string.join(extract_class_names("\"one\" asd \"two\""), ", "))
}

pub fn extract_class_names(input: String) -> List(String) {
  input
  |> string.to_graphemes
  |> extract([], "", "")
}

fn extract(
  input: List(String),
  accumulator: List(String),
  current_word: String,
  current_delimiter: String,
) -> List(String) {
  case input {
    [next_element, ..rest] -> {
      case current_delimiter {
        "" -> {
          case next_element {
            "\"" | "'" | "`" -> {
              extract(rest, accumulator, current_word, next_element)
            }
            _ -> {
              extract(rest, accumulator, current_word, "")
            }
          }
        }
        _ -> {
          case next_element == current_delimiter {
            True -> {
              let new_accumulator = list.append(accumulator, [current_word])
              extract(rest, new_accumulator, "", "")
            }
            False -> {
              case next_element {
                " " | "\n" -> {
                  case current_word {
                    "" -> {
                      extract(rest, accumulator, "", current_delimiter)
                    }
                    _ -> {
                      let new_acc = list.append(accumulator, [current_word])
                      extract(rest, new_acc, "", current_delimiter)
                    }
                  }
                }
                _ -> {
                  let next_word = current_word <> next_element
                  extract(rest, accumulator, next_word, current_delimiter)
                }
              }
            }
          }
        }
      }
    }
    _ -> accumulator
  }
}
