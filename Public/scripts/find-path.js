// The main entry point into the harmonic network.
// Starts out on the "I" chord.
// TODO: single tonic progression option
function findPath() {
  var path = ["I"];
  var redo = Array();
  continuePath(path, redo);
};

function continuePath(path, redo) {

  // prepareDoneStartOverButton(() => {
  //   updatePathLabel("All done: " + path);
  //   disableUndoButton();
  //   disableRedoButton();
  //   clearNeighborButtons();
  //   toggleDoneButtonToStartOver(() => {
  //     findPath();
  //   });
  // });

  // prepareUndoButton(() => {
  //   // TODO: Refactor into an API call "undo"
  //   redo.push(path.pop());
  //   continuePath(path,redo);
  // });

  // prepareRedoButton(() => {
  //   // TODO: Refactor into an API call "redo"
  //   path.push(redo.pop());
  //   continuePath(path,redo);
  // });

  // Update UI
  // updateUndoRedo(path,redo);
  updatePathLabel(path);

  // The current chord
  let current = path[path.length - 1];

  updatePathLabel("Path: " + path);

  // Collect only the nodes connected to `current`
  // FIXME: Refactor using `await`
  // Refactor body into own method
  let neighborsNode = document.getElementById("neighbors");

  const container = document.getElementById("container");
  const svgContainer = document.createElementNS("http://www.w3.org/2000/svg", "svg");
  svgContainer.setAttribute("width", 400);
  svgContainer.setAttribute("height", 400);

  const currentNode = makeNode("I", 200, 200, 50, "gray");

  // attach it to the container
  svgContainer.appendChild(currentNode);
  

  // Make a POST request with the current chord label to the address: "neighbors"
  post({ "label": current }, "neighbors", response => {

    let neighbors = JSON.parse(response);
    // Create buttons for each neighbor node
    for (var i = neighbors.length - 1; i >= 0; i--) {
      let neighbor = neighbors[i];
      const neighborNode = makeNode(neighbor.label, Math.random() * 300 + 50, Math.random() * 300 + 50, 50, "lightgray");
      svgContainer.appendChild(neighborNode);

      
      // let button = document.createElement("button");
      // // TODO: Reintegrate weights
      // button.innerHTML = neighbor.label + ": " + neighbor.probability;
      // button.name = neighbor;
      // button.className = "neighbor";
      // button.onclick = () => proceedWithChord(neighbor.label, path);
      // neighborsNode.insertBefore(button, neighborsNode.childNodes[0]);
    }
  });

  container.appendChild(svgContainer);
};

function makeNode(text, x, y, width, color, callback) {
  // Create group container
  const container = document.createElementNS("http://www.w3.org/2000/svg", "g");
  // Create circle
  const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
  circle.setAttribute("cx", x);
  circle.setAttribute("cy", y);
  circle.setAttribute("r", 0.5 * width);
  circle.setAttribute("fill", color);
  circle.setAttribute("stroke", "gray");
  // Create text label
  const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
  label.textContent = text;
  label.setAttribute("font-size", width / 3);
  label.setAttribute("x", x);
  label.setAttribute("y", y);
  label.setAttribute("fill", "white");
  label.setAttribute("text-anchor", "middle");
  label.setAttribute("dy", ".3em");
  // Compose SVG
  container.appendChild(circle);
  container.appendChild(label);
  return container
}

function proceedWithChord(chord, path) {
  path.push(chord);
  continuePath(path, []);
}

// Update UI

function updateUndoRedo(path, redo) {
  path.length > 1 ? enableUndoButton() : disableUndoButton();
  redo.length > 0 ? enableRedoButton() : disableRedoButton();
}

function updatePathLabel(label) {
  var pathLabel = document.getElementById("path-label");
  pathLabel.innerHTML = label;
}

function toggleDoneButtonToStartOver(callback) {
  console.log("toggle done button");
  let button = document.getElementById("done-start-over");
  button.onclick = callback;
  button.innerHTML = "Start Over";
}

function enableRedoButton() {
  let button = document.getElementById("redo");
  button.disabled = false;
}

function disableRedoButton() {
  let button = document.getElementById("redo");
  button.disabled = true;
}

function enableUndoButton() {
  let button = document.getElementById("undo");
  button.disabled = false;
}

function disableUndoButton() {
  let button = document.getElementById("undo");
  button.disabled = true;
}

// Prepare UI

function prepareDoneStartOverButton(callback) {
  let button = document.getElementById("done-start-over");
  button.onclick = callback;
  button.innerHTML = "Done";
}

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


function clearUndoRedoButtons() {
  var undoRedoNode = document.getElementById("undo-redo");
  undoRedoNode.innerHTML = "";
}

function clearNeighborButtons() {
  var neighborsNode = document.getElementById("neighbors");
  neighborsNode.innerHTML = "";
}