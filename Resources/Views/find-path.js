function continuePath(path, redo) {

  console.log("continue path redo: " + redo);

  // TODO: prepare todo / redo
  createUndoRedoButtons(path, redo);
  let current = path[path.length - 1];

  // Create path label
  let pathLabel = document.getElementById("path-label")
  pathLabel.innerHTML = "Path: " + path;

  // Create available neighbors buttons
  let div = document.createElement("div");
  div.name = "neighbors"
  div.id = "neighbors"

  let neighbors = bachMajor
    .filter(function(edge) {  return edge.source == current; })
    .map(function(edge) {  
      return { "node": edge.destination, "weight": edge.weight }
    });
  for (var i = 0; i < neighbors.length; i++) {
    let neighbor = neighbors[i];
    let button = document.createElement("button");
    button.innerHTML = neighbor.node + ": " + neighbor.weight;
    button.name = neighbor.node;
    button.onclick = function() {
      console.log("Clicked: " + button.name);
      var neighborsNode = document.getElementById("neighbors");
      neighborsNode.remove();
      path.push(button.name);
      continuePath(path, redo);  
    }
    div.insertBefore(button, div.childNodes[0]);
  }
  var body = document.getElementsByTagName("body")[0];
  body.appendChild(div);
}

function createUndoRedoButtons(path, redo) {

  // Remove undo and redo buttons
  var undoRedo = document.getElementById("undo-redo")
  if (!undoRedo) {
    undoRedo = document.createElement("div");
    undoRedo.id = "undo-redo";
  }

  while (undoRedo.hasChildNodes()) {
    undoRedo.removeChild(undoRedo.lastChild);
  }
  if (path.length > 1) {
    let undoButton = document.createElement("button");
    undoButton.innerHTML = "Undo"
    undoButton.onclick = function() {
      redo.push(path.pop())
      var neighborsNode = document.getElementById("neighbors");
      neighborsNode.remove();
      continuePath(path, redo);
    };
    undoRedo.appendChild(undoButton);
  }
  if (redo.length > 0) {
    let redoButton = document.createElement("button");
    redoButton.innerHTML = "Redo"
    redoButton.onclick = function() {
      var neighborsNode = document.getElementById("neighbors");
      neighborsNode.remove();
      path.push(redo.pop());
      continuePath(path, redo);
    };
    undoRedo.appendChild(redoButton);
  }
  var body = document.getElementsByTagName("body")[0];
  body.append(undoRedo);
}

function findPath() {
  var path = ["I"];
  var redo = Array();
  continuePath(path, redo);
}