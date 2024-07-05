\ Model allocationModel
\ LP format - for model browsing. Use MPS format to capture full model detail.
Minimize
  5 allocP_W[P1,w2] + 4 allocP_W[P2,w1] + 2 allocP_W[P2,w2]
   + 3 allocW_M[w1,c1] + 4 allocW_M[w1,c2] + 5 allocW_M[w1,c3]
   + 2 allocW_M[w2,c1] + allocW_M[w2,c2] + 2 allocW_M[w2,c3]
Subject To
 CapLimitConstr[P1]: allocP_W[P1,w1] + allocP_W[P1,w2] <= 200000
 CapLimitConstr[P2]: allocP_W[P2,w1] + allocP_W[P2,w2] <= 50000
 DemCovering[c1]: allocW_M[w1,c1] + allocW_M[w2,c1] = 50000
 DemCovering[c2]: allocW_M[w1,c2] + allocW_M[w2,c2] = 100000
 DemCovering[c3]: allocW_M[w1,c3] + allocW_M[w2,c3] = 50000
 equilibrium[w1]: allocP_W[P1,w1] + allocP_W[P2,w1] - allocW_M[w1,c1]
   - allocW_M[w1,c2] - allocW_M[w1,c3] = 0
 equilibrium[w2]: allocP_W[P1,w2] + allocP_W[P2,w2] - allocW_M[w2,c1]
   - allocW_M[w2,c2] - allocW_M[w2,c3] = 0
Bounds
End
