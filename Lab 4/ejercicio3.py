# Lab 4, Ejercicio 3
# Felipe Arias Russi 201914996 
# Mario Ruiz - 201920695 

from pyomo.environ import *
from pyomo.opt import SolverFactory
model = ConcreteModel()

tiles = range(1, 21)  
pipes = range(1, 8)   
tile_pipe_matrix = {
    (1, 1): 1, (5, 1): 1,
    (2, 2): 1, (3, 2): 1, (6, 2): 1, (7, 2): 1,
    (5, 3): 1, (9, 3): 1,
    (9, 4): 1, (10, 4): 1, (13, 4): 1, (14, 4): 1,
    (10, 5): 1, (11, 5): 1, (14, 5): 1, (15, 5): 1,
    (13, 6): 1, (17, 6): 1,
    (8, 7): 1, (12, 7): 1, (16, 7): 1, (19, 7): 1, (20, 7): 1
}

for tile in tiles:
    for pipe in pipes:
        tile_pipe_matrix.setdefault((tile, pipe), 0)

model.lift_tile = Var(tiles, domain=Binary)  
model.num_tiles_lifted = Objective(expr=sum(model.lift_tile[t] for t in tiles), sense=minimize)

def pipe_exposure_constraint(model, p):
    return sum(model.lift_tile[t] for t in tiles if tile_pipe_matrix[t, p]) >= 1

model.pipe_exposure = Constraint(pipes, rule=pipe_exposure_constraint)

solver = SolverFactory('glpk')
solver.solve(model)

lifted_tiles = [t for t in tiles if model.lift_tile[t].value == 1]
print(f"Tiles to be lifted: {lifted_tiles}")
print(f"Minimum number of tiles to lift: {len(lifted_tiles)}")
