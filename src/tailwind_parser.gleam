import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  io.println(string.join(extract_class_names("\"one\" asd \"two\""), ", "))
}

pub fn extract_class_names(input: String) -> List(String) {
  let delimiters: List(#(Int, String)) =
    string.split(input, "")
    |> list.index_map(fn(char, i) -> List(#(Int, String)) {
      case char {
        "\"" | "'" | "`" -> [#(i, char)]
        _ -> []
      }
    })
    |> list.flatten

  list.each(delimiters, fn(x) -> Nil { io.println(x.0 |> int.to_string <> x.1) })

  extract_indices_recursive([], delimiters, "")
  |> list.map(int.to_string)
  |> list.each(io.println)

  []
  // extract_class_names_recursive(input, [])
}

fn extract_indices_recursive(
  accumulator: List(Int),
  delimiters: List(#(Int, String)),
  current: String,
) -> List(Int) {
  case delimiters {
    [next_element, ..rest] -> {
      let #(index, char) = next_element

      case current {
        "" -> {
          let new_accumulator = list.append(accumulator, [index])
          extract_indices_recursive(new_accumulator, rest, char)
        }
        _ -> {
          io.println("current vs char vs del: " <> current <> "-" <> char)
          case char == current {
            True -> {
              let new_accumulator = list.append(accumulator, [index])
              extract_indices_recursive(new_accumulator, rest, "")
            }
            False -> {
              extract_indices_recursive(accumulator, rest, current)
            }
          }
        }
      }
    }
    _ -> accumulator
  }
}

fn extract_class_names_recursive(
  input: String,
  accumulator: List(String),
) -> List(String) {
  let input_with_indices =
    string.split(input, "")
    |> list.index_map(fn(x, i) { #(i, x) })

  let first_match_result =
    list.find(input_with_indices, fn(x) {
      let #(_, character) = x

      case character {
        "\"" | "'" | "`" -> True
        _ -> False
      }
    })

  let first_match = result_or_default_value(first_match_result)

  let second_match_result =
    list.find(input_with_indices, fn(x) {
      let #(index, character) = x
      first_match.0 >= 0 && index > first_match.0 && character == first_match.1
    })

  let second_match = result_or_default_value(second_match_result)

  let matched_classes =
    list.filter(input_with_indices, fn(x) {
      let #(index, _) = x
      first_match.0 > 0
      && second_match.0 > 0
      && index > first_match.0
      && index < second_match.0
    })
    |> list.map(fn(x) { x.1 })
    |> string.join("")

  let remaining_input =
    list.filter(input_with_indices, fn(x) { x.0 > second_match.0 })
    |> list.map(fn(x) { x.1 })
    |> string.join("")
    |> string.replace(each: "\n", with: "")

  case matched_classes {
    "" -> accumulator
    _ -> {
      let classes =
        string.split(matched_classes, " ")
        |> list.filter(fn(x) { !string.is_empty(x) })

      extract_class_names_recursive(
        remaining_input,
        list.concat([accumulator, classes]),
      )
    }
  }
}

fn result_or_default_value(
  result: Result(#(Int, String), Nil),
) -> #(Int, String) {
  case result {
    Ok(value) -> value
    Error(_) -> #(-1, "")
  }
}
