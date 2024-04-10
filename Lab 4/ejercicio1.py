# Lab 4, Ejercicio 1
# Felipe Arias Russi 201914996 
# Mario Ruiz - 201920695 

from pyomo.environ import *
from pyomo.opt import SolverFactory

model = ConcreteModel()

origins = ['O1', 'O2', 'O3']
destinations = ['D1', 'D2']
process_types = ['kernel', 'user']

supply = {('O1', 'kernel'): 60, ('O1', 'user'): 80, 
          ('O2', 'kernel'): 80, ('O2', 'user'): 50,
          ('O3', 'kernel'): 50, ('O3', 'user'): 50}

demand = {('D1', 'kernel'): 100, ('D1', 'user'): 60, 
          ('D2', 'kernel'): 90, ('D2', 'user'): 120}

costs = {('O1', 'D1'): 300, ('O1', 'D2'): 500,
         ('O2', 'D1'): 200, ('O2', 'D2'): 300,
         ('O3', 'D1'): 600, ('O3', 'D2'): 300}

model.x = Var(origins, destinations, process_types, domain=NonNegativeReals)

model.cost = Objective(expr=sum(model.x[o, d, pt] * costs[o, d] for o in origins for d in destinations for pt in process_types), sense=minimize)

model.supply_constraints = ConstraintList()
for o, pt in supply.keys():
    model.supply_constraints.add(sum(model.x[o, d, pt] for d in destinations) <= supply[o, pt])

model.demand_constraints = ConstraintList()
for d, pt in demand.keys():
    model.demand_constraints.add(sum(model.x[o, d, pt] for o in origins) == demand[d, pt])

solver = SolverFactory('glpk')
solver.solve(model)

for o in origins:
    for d in destinations:
        for pt in process_types:
            print(f'Processes from {o} to {d} of type {pt}: {model.x[o,d,pt].value}')
