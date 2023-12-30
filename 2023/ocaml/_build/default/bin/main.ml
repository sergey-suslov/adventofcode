let rec read_rec s_in =
  read_line ()
  |> fun x -> match x with "" -> s_in | s -> read_rec (s_in @ [s])

let find_digits l =
  List.filter (fun e -> match e with '0' .. '9' -> true | _ -> false) l

let sum =
  let input = read_rec [] in
  String.concat "\n" input |> print_endline ;
  let digits =
    List.map
      (fun e ->
        find_digits (e |> String.to_seq |> List.of_seq)
        |> fun dl ->
        String.of_seq (List.to_seq [List.hd dl; List.rev dl |> List.hd])
        |> int_of_string )
      input
  in
  List.fold_left (fun acc e -> acc + e) 0 digits

let () = Printf.printf "Sum: %d" sum
