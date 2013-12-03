Cell = -> x {
         -> y { List[x][y][EmptyList] }}

X = -> cell { At[cell][0] }
Y = -> cell { At[cell][1] }

# if we had list equality, we could just delegate to that
# and then this function would go away
CellEqual = -> cell1 {
              -> cell2 {
                Equal.(X[cell1])
                     .(X[cell2])
                     .(Equal[Y[cell1]][Y[cell2]])
                     .(False)}}
