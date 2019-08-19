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

function continuePath(path, redo) {
  clearNeighborButtons()
  updatePathLabel(path);

  prepareUndoButton(() => {
    // TODO: Refactor into an API call "undo"
    redo.push(path.pop());
    continuePath(path,redo);
  });

  prepareRedoButton(() => {
    // TODO: Refactor into an API call "redo"
    path.push(redo.pop());
    continuePath(path,redo);
  });

  updateUndoRedo(path,redo);

  // The current chord
  let current = path[path.length - 1];

  // Create path label
  let pathLabel = document.getElementById("path-label")
  pathLabel.innerHTML = "Path: " + path;

  // Collect only the nodes connected to `current`
  // FIXME: Refactor using `await`
  // Refactor body into own method
  let neighborsNode = document.getElementById("neighbors");
  post({ "label": current }, "neighbors", response => {
    let neighbors = JSON.parse(response);
    // Create buttons for each neighbor node
    for (var i = 0; i < neighbors.length; i++) {
      let neighbor = neighbors[i];
      let button = document.createElement("button");
      // TODO: Reintegrate weights
      button.innerHTML = neighbor;
      button.name = neighbor;
      button.onclick = () => proceedWithChord(neighbor, path);
      neighborsNode.insertBefore(button, neighborsNode.childNodes[0]);
    }
  });
};

function proceedWithChord(chord, path) {
  path.push(chord);
  continuePath(path, []);
}

// Update UI

function updateUndoRedo(path, redo) {
  path.length > 1 ? enableUndoButton() : disableUndoButton()
  redo.length > 0 ? enableRedoButton() : disableRedoButton()
}

function updatePathLabel(path) {
  var pathLabel = document.getElementById("path-label")
  pathLabel.innerHTML = "Path: " + path;
}
// Prepare UI

function prepareRedoButton(callback) {
  let button = document.getElementById("redo")
  button.innerHTML = "Redo"
  button.onclick = callback;
}

function prepareUndoButton(callback) {
  let button = document.getElementById("undo")
  button.innerHTML = "Undo"
  button.onclick = callback;
}

function enableRedoButton() {
  let button = document.getElementById("redo")
  button.innerHTML = "Redo"
}

function disableRedoButton() {
  let button = document.getElementById("redo")
  button.innerHTML = "xRedox"
}

function enableUndoButton() {
  let button = document.getElementById("undo")
  button.innerHTML = "Undo"
}

function disableUndoButton() {
  let button = document.getElementById("undo")
  button.innerHTML = "xUndox"
}

function clearNeighborButtons() {
  var neighborsNode = document.getElementById("neighbors");
  neighborsNode.innerHTML = "";
}