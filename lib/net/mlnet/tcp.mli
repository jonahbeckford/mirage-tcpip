(*
 * Copyright (c) 2010 Anil Madhavapeddy <anil@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

open Nettypes

type t
type pcb
type view = OS.Istring.View.t
type data = Mpl.Tcp.o OS.Istring.View.data

type channel = {
  pcb: pcb;
  rxq: view Lwt_sequence.t;   (* RX segment queue *)
  rxc: unit Lwt_condition.t;  (* Receive condition mutex *)
  txq: data Lwt_sequence.t;   (* TX segment queue *)
  txc: unit Lwt_condition.t;  (* Transmit condition mutex *)
  mutable tx_closed: bool;    (* If our transmit side is closed *)
}

module Tx: sig
  val closed : channel -> bool
  val close : channel -> unit
end

module Rx: sig
  val closed : channel -> bool
end

val input: t -> Mpl.Ipv4.o -> Mpl.Tcp.o -> unit Lwt.t
val output: t -> dest_ip:ipv4_addr -> (OS.Istring.View.t -> Mpl.Tcp.o) -> unit Lwt.t
val listen: t -> int -> (pcb -> (channel * unit Lwt.t)) -> unit
val create : Ipv4.t -> t * unit Lwt.t


(* Temporary XXX *)
val output_timer: t -> pcb -> unit Lwt.t
