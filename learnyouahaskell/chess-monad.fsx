type KnightPos = int * int

type ListMonad() =
    member __.Bind (m, f) = m |> List.map (fun x -> f x) |> List.concat
    member __.Return(x) = [x]
    member __.ReturnFrom(x) = x
    member __.Zero() = []

let lm = ListMonad()

let moveKnight (c, r) =
    [   c + 2, r - 1
        c + 2, r + 2
        c - 2, r - 1
        c - 2, r + 2
        c + 1, r - 2
        c + 1, r + 2
        c - 1, r - 2
        c - 1, r + 2 ]
    |> List.filter (fun (c, r) -> c >= 1 && c <= 8 && r >= 1 && r <= 8)

(1, 1) |> moveKnight
moveKnight (6, 2)

module SeqMonad =
    let bind m f = m |> Seq.map (fun x -> f x) |> Seq.concat
    let (>>=) = bind
    // monadic compose
    let (<=<) f g = (fun x -> g x >>= f)
    let ret x = seq { yield x }

open SeqMonad

type SeqMonad() =
    member __.Bind (m, f) = bind
    member __.Return(x) = ret x
    member __.ReturnFrom(x) = x
    member __.Zero() = Seq.empty

let seqMonad = SeqMonad()

let moveKnight' (c, r) =
    seq {
        yield c + 2, r - 1
        yield c + 2, r + 2
        yield c - 2, r - 1
        yield c - 2, r + 2
        yield c + 1, r - 2
        yield c + 1, r + 2
        yield c - 1, r - 2
        yield c - 1, r + 2 }
    |> Seq.filter (fun (c, r) -> c >= 1 && c <= 8 && r >= 1 && r <= 8)

let in3 (start: KnightPos) = seqMonad {
    let! first = moveKnight' start
    let! second = moveKnight' first
    return! moveKnight' second
}

[1, 1] >>= moveKnight >>= moveKnight >>= moveKnight |> List.ofSeq
(1, 1) |> in3 |> List.ofSeq

let canReachIn3 startPos endPos = startPos |> in3 |> Seq.exists ((=) endPos)

canReachIn3 (6, 2) (6, 1)
canReachIn3 (6, 2) (7, 3)

let inMany n start = start |> Seq.fold (<=<) ret (Seq.replicate n moveKnight)

(1, 1) |> inMany 3 |> List.ofSeq
