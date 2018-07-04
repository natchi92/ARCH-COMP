theory ARCH_NLN_Gen
imports Main
begin

text \<open>The file \<open>isabelle_hol_ode_numerics.ML\<close> contains the code generated from the verified
  algorithm.
\<close>

ML_file "isabelle_hol_ode_numerics.ML"

ML \<open> open Isabelle_HOL_ODE_Numerics \<close>


text \<open>This is an archaic way to define the ode of the van der Pol system.
  (It has actually been generated from a string like \<open>[X!1, X!1 * (1 - (X!0)\<^sup>2) - X!0]\<close>)
\<close>

ML \<open>
val van_der_pol = [Var (Nat 1),
    Add (Mult (Var (Nat 1),
               Add (Num (Float (Int_of_integer 1, Int_of_integer 0)),
                    Minus (Mult (Var (Nat 0), Var (Nat 0))))),
         Minus (Var (Nat 0)))]
\<close>

text \<open>This defines the ode of the Laub-Loomis model.
  It looks cumbersome, but was actually generated from a string that looked like this:
"[1,
    1.4 * X ! 3 - 0.9 * X ! 1,
    2.5 * X ! 5 - 1.5 * X ! 2,
    0.6 * X ! 7 - 0.8 * X ! 2 * X ! 3,
    2           - 1.3 * X ! 3 * X ! 4,
    0.7 * X ! 1 -       X ! 4 * X ! 5,
    0.3 * X ! 1 - 3.1 * X ! 6,
    1.8 * X ! 6 - 1.5 * X ! 2 * X ! 7]"
\<close>
ML \<open>
 val laub_loomis =
   [Num (Float (Int_of_integer 1, Int_of_integer 0)),
    Add (Mult (Mult (Num (Float (Int_of_integer 14, Int_of_integer 0)),
                     Inverse (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
               Var (Nat 3)),
         Minus
          (
             Mult (Mult (Num (Float (Int_of_integer 9, Int_of_integer 0)),
                         Inverse (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
                   Var (Nat 1))
             )),
    Add (Mult (Mult (Num (Float (Int_of_integer 25, Int_of_integer 0)),
                     Inverse (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
               Var (Nat 5)),
         Minus
          (
             Mult (Mult (Num (Float (Int_of_integer 15, Int_of_integer 0)),
                         Inverse (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
                   Var (Nat 2))
             )),
    Add (Mult (Mult (Num (Float (Int_of_integer 6, Int_of_integer 0)),
                     Inverse (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
               Var (Nat 7)),
         Minus
          (
             Mult (Mult (Mult (Num (Float (Int_of_integer 8, Int_of_integer 0)),
                               Inverse
                                (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
                         Var (Nat 2)),
                   Var (Nat 3))
             )),
    Add (Num (Float (Int_of_integer 2, Int_of_integer 0)),
         Minus
          (
             Mult (Mult (Mult (Num (Float (Int_of_integer 13, Int_of_integer 0)),
                               Inverse
                                (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
                         Var (Nat 3)),
                   Var (Nat 4))
             )),
    Add (Mult (Mult (Num (Float (Int_of_integer 7, Int_of_integer 0)),
                     Inverse (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
               Var (Nat 1)),
         Minus (Mult (Var (Nat 4), Var (Nat 5)))),
    Add (Mult (Mult (Num (Float (Int_of_integer 3, Int_of_integer 0)),
                     Inverse (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
               Var (Nat 1)),
         Minus
          (
             Mult (Mult (Num (Float (Int_of_integer 31, Int_of_integer 0)),
                         Inverse (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
                   Var (Nat 6))
             )),
    Add (Mult (Mult (Num (Float (Int_of_integer 18, Int_of_integer 0)),
                     Inverse (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
               Var (Nat 6)),
         Minus
          (
             Mult (Mult (Mult (Num (Float (Int_of_integer 15, Int_of_integer 0)),
                               Inverse
                                (Num (Float (Int_of_integer 10, Int_of_integer 0)))),
                         Var (Nat 2)),
                   Var (Nat 7))
             ))]\<close>
ML \<open>
fun R x = lrat x 1
fun IVL xs ys = ((Ereal (R 1), Ereal (R 1)), (aforms_of_ivls xs ys, NONE))
fun eIVL x = ((Ereal (R 1), Ereal (R 1)), (x, NONE))
\<close>



subsection \<open>Van der Pol\<close>

ML \<open>
File.open_output
(fn outstream =>
  let
    (* Initial Sets *)
    val initial_sets = [IVL [lrat 125 100, lrat 235 100] [lrat (155) 100, lrat 245 100]]

    (* summarization threshold for affine forms *)
    val reduce_over = 20
    val reduce_with = 10
    
    (* error tolerance (2^(-...))*)
    val error_tol   = 12
    
    (* plot: projection onto variables x_0, x_1, and color in hex *)
    val plot_info = [(0, (1, "0x000000"))]

    (* hybridization at x_0 = 15/10, 0 <= x_1 <= 2*) 
    val hyb = [[xsec2a (lrat 3 2) (R ~2, R 0)]] 
   
    (* ODE: *)
    val ode = van_der_pol

    val dim = length ode

    (* return is expected within [1, 25/10] .. [2, 25/10] *)
    val ry = (lrat (25) 10)
    val return_sctn = (code_sctna dim 1 (ry))
    val return_ivl = ([R 1, ry], [R 2, ry])

    val ro = code_ro 1 1 1 1 1 (* this encodes no splitting *)
  in
  solve_poincare_map_aform (code_options (reduce_over) (reduce_with) error_tol plot_info (File.output outstream))
      ode true_form
      (fn x => DRETURN (([], [x])))
      []
      (map (fn s =>(s, ro) ) hyb)
      return_ivl
      return_sctn
      ro
      initial_sets
    end
)(  (* filename: *) "vanderpol.out"
  |> Path.explode
  |> (File.full_path o Resources.master_directory o Proof_Context.theory_of) @{context})
 \<close>


subsection \<open>Laub Loomis\<close>

text \<open>split the initial set\<close>

ML \<open>
fun split_dims D ss X = fold (fn i => fn xs => split_aforms_list xs i (nth ss i)) (map Nat (0 upto (D - 1))) [X]

fun laub_initial width =
  let
      val c = [120, 105, 150, 240, 100, 10, 45]
  in IVL (R 0::map (fn x => lrat (x - width) 100) c)
                             (R 0::map (fn x => urat (x + width) 100) c)
  end
\<close>

ML \<open>
fun single_laub_loomis outstream e m N initial_set = 
    let
      (* Integrate for how long? *)
      val time = (R 20)
  
      (* summarization threshold for affine forms *)
    val reduce_over = m
    val reduce_with = N
      
      (* error tolerance (2^(-...))*)
      val error_tol   = e
      
      (* plot: projection onto variables x_0, x_1, and color in hex *)
      val plot_info = [
          (0, (1, "0x000000")),
          (0, (2, "0x00007f")),
          (0, (3, "0x0000ff")),
          (0, (4, "0x7f007f")),
          (0, (5, "0x7f00ff")),
          (0, (6, "0xff00ff")),
          (0, (7, "0x7f0000")),
          (2, (6, "0x00ff00")),
          (5, (7, "0x007f00"))
        ]

      (* ODE: *)
      val ode = laub_loomis
  
    in
    solve_one_step_until_time_aform (code_options reduce_over reduce_with error_tol plot_info (File.output outstream))
      ode
      true_form
      initial_set
      false
      time
      end\<close>

ML \<open>
fun run_laub_loomis filename e m N initial_sets = 
  (File.open_output (fn outstream => map (single_laub_loomis outstream e m N) initial_sets)
  (  (* filename: *) filename
    |> Path.explode
    |> (File.full_path o Resources.master_directory o Proof_Context.theory_of) @{context}))
 \<close>

ML_val \<open>run_laub_loomis "laubloomis001.out" 12 60 50 [laub_initial 1]\<close>
ML_val \<open>run_laub_loomis  "laubloomis010.out" 14 100 50 (map eIVL (split_dims 8 (map Nat [0,1,1,1,0,0,0,0]) (fst (snd (laub_initial 10)))))\<close>


end
