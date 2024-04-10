# Lab 4, Ejercicio 2
# Felipe Arias Russi 201914996 
# Mario Ruiz - 201920695 

from pyomo.environ import *
from pyomo.opt import SolverFactory
model = ConcreteModel()

towns = range(1, 7)  
drive_times = {(1, 1): 0, (1, 2): 10, (1, 3): 20, (1, 4): 30, (1, 5): 30, (1, 6): 20,
               (2, 1): 10, (2, 2): 0, (2, 3): 25, (2, 4): 35, (2, 5): 20, (2, 6): 10,
               (3, 1): 20, (3, 2): 25, (3, 3): 0, (3, 4): 15, (3, 5): 30, (3, 6): 20,
               (4, 1): 30, (4, 2): 35, (4, 3): 15, (4, 4): 0, (4, 5): 15, (4, 6): 25,
               (5, 1): 30, (5, 2): 20, (5, 3): 30, (5, 4): 15, (5, 5): 0, (5, 6): 14,
               (6, 1): 20, (6, 2): 10, (6, 3): 20, (6, 4): 25, (6, 5): 14, (6, 6): 0}

max_time = 15  
model.build_fire_station = Var(towns, domain=Binary)  
model.num_fire_stations = Objective(expr=sum(model.build_fire_station[t] for t in towns), sense=minimize)

def coverage_constraint(model, j):
    return sum(model.build_fire_station[i] for i in towns if drive_times[i, j] <= max_time) >= 1

model.coverage = Constraint(towns, rule=coverage_constraint)

solver = SolverFactory('glpk')
solver.solve(model)

fire_stations = [t for t in towns if model.build_fire_station[t].value == 1]
print(f"Number of fire stations to build: {len(fire_stations)}")
print(f"Build fire stations in towns: {fire_stations}")
