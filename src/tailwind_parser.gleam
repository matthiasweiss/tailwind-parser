import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  io.println(string.join(extract_class_names("\"one\" asd \"two\""), ", "))
}

pub fn extract_class_names(input: String) -> List(String) {
  extract_class_names_recursive(input, [])
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
