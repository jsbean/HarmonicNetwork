function continuePath(path, redo) {
  
  // Prepare undo redo div
  createUndoRedoButtons(path, redo);

  // The current chord
  let current = path[path.length - 1];

  // Create path label
  let pathLabel = document.getElementById("path-label")
  pathLabel.innerHTML = "Path: " + path;

  // Create available neighbors div
  let div = document.createElement("div");
  div.name = "neighbors"
  div.id = "neighbors"

  // Collect only the nodes connected to `current`
  // FIXME: Refactor using `await`
  post({ "label": current }, "neighbors", response => {
      let neighbors = JSON.parse(response);
      console.log(response);
      // Create buttons for each neighbor node
      for (var i = 0; i < neighbors.length; i++) {
        let neighbor = neighbors[i];
        let button = document.createElement("button");
        // TODO: Reintegrate weights
        button.innerHTML = neighbor;
        button.name = neighbor;
        button.onclick = function() {
          var neighborsNode = document.getElementById("neighbors");
          neighborsNode.remove();
          path.push(button.name);
          continuePath(path, redo);  
        }
        div.insertBefore(button, div.childNodes[0]);
      }

      // Add neighbor buttons to body
      var body = document.getElementsByTagName("body")[0];
      body.appendChild(div);
    });
};

function createUndoRedoButtons(path, redo) {

  // Prepare the undo-redo div if it doesn't exist yet
  var undoRedo = document.getElementById("undo-redo")
  if (!undoRedo) {
    undoRedo = document.createElement("div");
    undoRedo.id = "undo-redo";
  }

  // Start clean: remove undo and redo buttons
  while (undoRedo.hasChildNodes()) {
    undoRedo.removeChild(undoRedo.lastChild);
  }

  // If we are past the "I" chord, allow user to "undo" last decision
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

  // If we have undone anything, expose a "redo" button
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

  // Add the undo-redo div
  var body = document.getElementsByTagName("body")[0];
  body.append(undoRedo);
};

// The main entry point into the harmonic network.
// Starts out on the "I" chord.
// TODO: single tonic progression option
// TODO: done option
// TODO: try again? option
function findPath() {
  var path = ["I"];
  var redo = Array();
  continuePath(path, redo);
};
