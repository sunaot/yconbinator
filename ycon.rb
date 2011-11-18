#! ruby
# coding: utf-8
#
# http://d.hatena.ne.jp/nowokay/20090409#1239268405

require 'expectations'
Expectations do
  
  # boolean
  t = (-> x { (-> y {x}) })
  f = (-> x { (-> y {y}) })
  
  expect(0) { t[0][1] }
  expect(1) { f[0][1] }

  bl = (-> b {b ? t : f})
  expect(:t) { bl[3 < 4][:t][:f] }
  expect(:f) { bl[3 < 1][:t][:f] }

  # loop
  y = (-> f { (-> x {f[x[x]]})[(-> x {f[x[x]]})] })
  z = (-> f { (-> x {(-> m {f[x[x]][m]})})[(-> x {(-> m {f[x[x]][m]})})] })

  fib = (-> f {(-> n { n<2 ? n : (f[n-1]+f[n-2]) })})
  expect(13) { z[fib][7] }

  # loop with bool
  fib_lazy = (-> f {(-> n { bl[n<2][->{n}][->{f[n-1]+f[n-2]}][] })})
  expect(13) { z[fib_lazy][7] }

  # number
  zero = (-> f {(-> x {x})})
  one  = (-> f {(-> x {f[x]})})
  two  = (-> f {(-> x {f[f[x]]})})
  expect(0) { zero[(-> x {x+1})][0] }
  expect(1) {  one[(-> x {x+1})][0] }
  expect(2) {  two[(-> x {x+1})][0] }

  to_i = (-> n {n[(-> x {x+1})][0]})
  succ = (-> n {(-> f {(-> x {f[n[f][x]]})})})
  expect(3) { to_i[succ[two]] }

  # add m n = m + n
  add = (-> m {(-> n {(-> f {(-> x {n[f][m[f][x]]})})})})
  expect(3) { to_i[add[one][two]] }

  # add in procedure
  i_add = (-> m {(-> n {
    f = (-> x {x+1})
    x = 0
    i_n = n[f][x] 
    m_plus_n = m[f][i_n]
  })})
  expect(3) { i_add[one][two] }

end

