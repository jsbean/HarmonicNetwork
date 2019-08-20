// Constants
const nodeWidth = 50;
const nodeDistance = 115;

// The main entry point into the harmonic network.
// Starts out on the "I" chord.
// TODO: single tonic progression option
function findPath() {
  var path = ["I"];
  var redo = Array();
  continuePath(path, redo);
};

function continuePath(path, redo) {

  const width = 400;
  const height = 400;
  const centroid = { "x": 0.5 * width, "y": 0.5 * height };

  const container = document.getElementById("container");
  const svgContainer = document.createElementNS("http://www.w3.org/2000/svg", "svg");
  svgContainer.setAttribute("width", width);
  svgContainer.setAttribute("height", height);

  prepareDoneStartOverButton(() => {
    updatePathLabel("All done: " + path);
    disableUndoButton();
    disableRedoButton();  
    toggleDoneButtonToStartOver(() => {
      findPath();
    });
  });

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

  // Update UI
  updateUndoRedo(path,redo);
  updatePathLabel(path);
  updatePathLabel("Path: " + path);

  // The current chord
  let current = path[path.length - 1];

  // Make a POST request with the current chord label to the address: "neighbors"
  post({ "label": current }, "neighbors", response => {

    // Parse response (array of type { "label": String, "probability": Number })
    let neighbors = JSON.parse(response);

    // Create buttons for each neighbor node
    for (var i = neighbors.length - 1; i >= 0; i--) {

      // Extract model
      let neighbor = neighbors[i];

      const startAngleInRadians = -0.5 * Math.PI;
      const angleInRadians = (i / neighbors.length) * 2 * Math.PI + startAngleInRadians;
      const x = centroid.x + nodeDistance * Math.cos(angleInRadians);
      const y = centroid.y + nodeDistance * Math.sin(angleInRadians);

      // Create node
      const neighborNode = makeNode(
        neighbor.label, 
        /*x*/ x, 
        /*y*/ y, 
        /*width*/ nodeWidth,
        "lightgray",
        () => { 
          container.removeChild(svgContainer);
          proceedWithChord(neighbor.label, path)
        }
      );

      // Create arrow from source to each neighbor
      const edgeX = centroid.x + (nodeDistance - 0.5 * nodeWidth) * Math.cos(angleInRadians);
      const edgeY = centroid.y + (nodeDistance - 0.5 * nodeWidth) * Math.sin(angleInRadians);
      const edge = makeEdge(centroid, { "x": edgeX, "y": edgeY });
      svgContainer.appendChild(edge);

      // Compose SVG
      svgContainer.appendChild(neighborNode);

      const currentNode = makeNode(current, centroid.x, centroid.y, nodeWidth, "gray");
      svgContainer.appendChild(currentNode);
      container.appendChild(svgContainer);
    }
  });
};

function makeEdge(source, destination) {
  const group = document.createElementNS("http://www.w3.org/2000/svg", "g");
  const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
  line.setAttribute("x1", source.x);
  line.setAttribute("y1", source.y);
  line.setAttribute("x2", destination.x);
  line.setAttribute("y2", destination.y);
  line.setAttribute("stroke", "lightgray");
  group.appendChild(line);
  return group
}

function makeNode(text, x, y, width, color, callback) {
  // Create group container
  const group = document.createElementNS("http://www.w3.org/2000/svg", "g");
  group.onclick = callback;
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
  label.setAttribute("pointer-events", "none");
  label.onclick = callback;
  // Compose SVG
  group.appendChild(circle);
  group.appendChild(label);
  return group
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

function removeChildren(node) {
    node.innerHTML = "";
}