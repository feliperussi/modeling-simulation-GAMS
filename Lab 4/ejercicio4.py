# Lab 4, Ejercicio 4
# Felipe Arias Russi 201914996 
# Mario Ruiz - 201920695 

from pyomo.environ import *
from pyomo.opt import SolverFactory
import matplotlib.pyplot as plt
model = ConcreteModel()

nodes = ['1', '2', '3', '4', '5', '6', '7']

coord = {'1': (20, 6), '2': (22, 1), '3': (9, 2), 
         '4': (3, 25), '5': (21, 10), '6': (29, 2), '7': (14, 12)}

dist = {(i, j): sqrt((coord[i][0] - coord[j][0])**2 + (coord[i][1] - coord[j][1])**2) for i in nodes for j in nodes}

cost = {(i, j): dist[i, j] if dist[i, j] <= 20 else 99999 for i in nodes for j in nodes}
for i in nodes:
    cost[i, i] = 9999

model.x = Var(((i, j) for i in nodes for j in nodes), within=Binary)

model.z = Objective(expr=sum(cost[i, j] * model.x[i, j] for i in nodes for j in nodes), sense=minimize)

def source_rule(model, i):
    if i == '4':
        return sum(model.x[i, j] for j in nodes) == 1
    else:
        return Constraint.Skip
model.sourceNode = Constraint(nodes, rule=source_rule)

def destination_rule(model, j):
    if j == '6':
        return sum(model.x[i, j] for i in nodes) == 1
    else:
        return Constraint.Skip
model.destinationNode = Constraint(nodes, rule=destination_rule)

def intermediate_rule(model, i):
    if i not in ['4', '6']:
        return sum(model.x[i, j] for j in nodes) - sum(model.x[j, i] for j in nodes) == 0
    else:
        return Constraint.Skip
model.intermediateNode = Constraint(nodes, rule=intermediate_rule)

solver = SolverFactory('glpk')
solver.solve(model)

selected_links = [(i, j) for i in nodes for j in nodes if model.x[i, j].value == 1]
print("Enlaces seleccionados para la ruta de mínimo costo:", selected_links)
print("Valor de la función objetivo (z):", model.z())
possible_links = [(i, j) for i in nodes for j in nodes if i != j and dist[i, j] <= 20]

plt.figure(figsize=(10, 8))

for node, (x, y) in coord.items():
    plt.scatter(x, y, color='blue')
    plt.text(x+0.5, y+0.5, node, fontsize=12)

for i, j in possible_links:
    plt.plot([coord[i][0], coord[j][0]], [coord[i][1], coord[j][1]], color='lightgray', linestyle='--', zorder=1)

for i, j in selected_links:
    plt.plot([coord[i][0], coord[j][0]], [coord[i][1], coord[j][1]], color='red', linewidth=2, zorder=2)

plt.xlabel('Coordenada X')
plt.ylabel('Coordenada Y')
plt.title('Red de Nodos con Ruta de Mínimo Costo Resaltada')
plt.grid(True)
plt.show()