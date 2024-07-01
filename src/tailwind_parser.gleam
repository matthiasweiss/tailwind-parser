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
  active_delimiter: String,
) -> List(String) {
  case input {
    [next_char, ..rest] -> {
      case active_delimiter {
        "" -> {
          case next_char {
            "\"" | "'" | "`" -> {
              extract(rest, accumulator, current_word, next_char)
            }
            _ -> {
              extract(rest, accumulator, current_word, "")
            }
          }
        }
        _ -> {
          case next_char == active_delimiter {
            True -> {
              let new_accumulator = list.append(accumulator, [current_word])
              extract(rest, new_accumulator, "", "")
            }
            False -> {
              case next_char {
                " " | "\n" -> {
                  case current_word {
                    "" -> {
                      extract(rest, accumulator, "", active_delimiter)
                    }
                    _ -> {
                      let new_acc = list.append(accumulator, [current_word])
                      extract(rest, new_acc, "", active_delimiter)
                    }
                  }
                }
                _ -> {
                  let next_word = current_word <> next_char
                  extract(rest, accumulator, next_word, active_delimiter)
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
