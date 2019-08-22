// Constants
// FIXME: Derive from screen size
const nodeWidth = 20;
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

  // FIXME: Derive size from screen size
  const width = 400;
  const height = 400;

  const container = document.getElementById("container");
  const svgContainer = document.getElementById("graph-view");
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

  // TODO: Handle switching between views
  presentWebView(path);
  //presentNeighborView(current, path);
};

function presentWebView(path) {
  const svgContainer = document.getElementById("graph-view");
  post(path.map(node => { return { "label": node } }), "webview", response => {
    const viewModel = JSON.parse(response);
    const nodes = viewModel.nodes;
    const edges = viewModel.edges;
    
    removeChildren(svgContainer);

    // Add edges (first for now for layering behind nodes)
    // TODO: Add edges group
    edges.forEach(edgeViewModel => {
      const edgeView = makeEdge(
          edgeViewModel.source,
          edgeViewModel.destination,
          edgeViewModel.style.color,
        )
        svgContainer.appendChild(edgeView);
    });

    // Add nodes (first for now for layering in front of edges)
    // TODO: Add nodes group
    nodes.forEach(nodeViewModel => {
      const closure = () => {
        path.push(nodeViewModel.label);
        continuePath(path,[]);
      }
      const nodeView = makeNode(
        nodeViewModel.label, 
        nodeViewModel.position, 
        2 * nodeViewModel.radius, 
        nodeViewModel.style.fillColor,
        nodeViewModel.style.strokeColor,
        nodeViewModel.isSelectable ? closure : { }
      );
      svgContainer.appendChild(nodeView);
    });

    container.insertBefore(svgContainer, container.childNodes[0]);
  })
}

function presentNeighborView(current, path) {
  const svgContainer = document.getElementById("graph-view");

  // FIXME: Derive size from screen
  const width = 400;
  const height = 400;

  const centroid = new Point(0.5 * width, 0.5 * height);


    // Make a POST request with the current chord label to the address: "neighbors"
  post({ "label": current }, "neighbors", response => {

    // Parse response (array of type { "label": String, "weight": Number })
    let neighbors = JSON.parse(response);

    let weights = neighbors.map(color => color.weight)
    let heaviest = Math.max(...weights);
    let colorAdjust = 1 - heaviest;

    // FIXME: Only remove nodes that are currently present, but shan't remain
    removeChildren(svgContainer);

    // Create buttons for each neighbor node
    for (var i = neighbors.length - 1; i >= 0; i--) {

      // Extract model
      let neighbor = neighbors[i];

      // Compute position of neighbor node
      const startAngleInRadians = -0.5 * Math.PI;
      const angleInRadians = (i / neighbors.length) * 2 * Math.PI + startAngleInRadians;
      const position = new Point(
        centroid.x + nodeDistance * Math.cos(angleInRadians),
        centroid.y + nodeDistance * Math.sin(angleInRadians)
      );

      // Create node
      // FIXME: Only create node is currently not present, but is needed
      const neighborNode = makeNode(
        neighbor.label, 
        position,
        nodeWidth,
        "lightgray",
        () => { 
          proceedWithChord(neighbor.label, path)
        }
      );

      let colorValue = 1 - (neighbor.weight / heaviest)

      let edgeConnectionPoint = new Point(
        centroid.x + (nodeDistance - 0.5 * nodeWidth) * Math.cos(angleInRadians),
        centroid.y + (nodeDistance - 0.5 * nodeWidth) * Math.sin(angleInRadians)
      );

      // Create arrow from source to each neighbor
      let color = "rgb(" + 
        Math.round(colorValue * 256) + "," +
        Math.round(colorValue * 256) + "," +
        Math.round(colorValue * 256) +
      ")"

      const edge = makeEdge(centroid, edgeConnectionPoint, color);
      svgContainer.appendChild(edge);

      // Compose SVG
      svgContainer.appendChild(neighborNode);

      const currentNode = makeNode(current, centroid, nodeWidth, "gray");
      svgContainer.appendChild(currentNode);
      container.insertBefore(svgContainer, container.childNodes[0]);
    }
  });
}

// TODO: Refactor into class Edge
function makeEdge(source, destination, color) {

  let dx = destination.x - source.x
  let dy = destination.y - source.y
  let angle = Math.atan2(dy,dx);

  // FIXME: Factor out magic number '5'
  const lineEnd = new Point(
    destination.x - 2.5 * Math.cos(angle),
    destination.y - 2.5 * Math.sin(angle)
  ); 
  const line = makeLine(source, lineEnd, color);
  const arrowhead = makeArrowhead(destination, angle, color);

  // Compose SVG
  const group = document.createElementNS("http://www.w3.org/2000/svg", "g");
  group.appendChild(line);
  group.appendChild(arrowhead);
  return group
}

// TODO: Refactor into class Arrowhead
function makeArrowhead(point, angle, color) {
  const arrowhead = document.createElementNS("http://www.w3.org/2000/svg", "path");
  // FIXME: Factor out magic number
  let sideLength = 5;
  let angleA = angle - (Math.PI / 7);
  let angleB = angle + (Math.PI / 7);
  let ax = point.x - sideLength * Math.cos(angleA);
  let ay = point.y - sideLength * Math.sin(angleA);
  let bx = point.x - sideLength * Math.cos(angleB);
  let by = point.y - sideLength * Math.sin(angleB);
  // In the bay of the barb
  let cx = point.x - 0.75 * sideLength * Math.cos(angle);
  let cy = point.y - 0.75 * sideLength * Math.sin(angle);
  // Set path
  arrowhead.setAttribute("d",
    "M " + point.x + " " + point.y + " " +
    "L " + ax + " " + ay + " " +
    "L " + cx + " " + cy + " " +
    "L " + bx + " " + by + " " +
    "Z"
  );
  arrowhead.setAttribute("fill", svgColor(color));
  return arrowhead
}

// TODO: Refactor into class Line
function makeLine(source, destination, color) {
  const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
  line.setAttribute("x1", source.x);
  line.setAttribute("y1", source.y);
  line.setAttribute("x2", destination.x);
  line.setAttribute("y2", destination.y);
  line.setAttribute("stroke", svgColor(color));
  // FIXME: Factor out magic number
  line.setAttribute("stroke-width", 1);
  return line
}

// Takes in a color object with r,g,b,a values in [0,1]
// Returns a string in the form "rgba(r,g,b,a)" with values in [0,256)
function svgColor(color) {
  return "rgba(" + 
    Math.floor(color.red * 256) + "," + 
    Math.floor(color.green * 256) + "," + 
    Math.floor(color.blue * 256) + "," + 
    Math.floor(color.alpha * 256) + 
  ")"
}

// TODO: Refactor into class ChordNode
function makeNode(text, position, width, fillColor, strokeColor, callback) {

  // Create group container
  const group = document.createElementNS("http://www.w3.org/2000/svg", "g");
  group.onclick = callback;
  // Create circle
  const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
  circle.setAttribute("cx", position.x);
  circle.setAttribute("cy", position.y);
  circle.setAttribute("r", 0.5 * width);
  circle.setAttribute("fill", svgColor(fillColor));
  circle.setAttribute("stroke", svgColor(strokeColor));
  // Create text label
  const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
  label.textContent = text;
  label.setAttribute("font-size", width / 3);
  label.setAttribute("x", position.x);
  label.setAttribute("y", position.y);
  label.setAttribute("fill", "white");
  label.setAttribute("text-anchor", "middle");
  label.setAttribute("dy", ".3em");
  label.setAttribute("pointer-events", "none");
  label.onclick = callback;
  // Compose SVG
  group.appendChild(circle);
  group.appendChild(label);
  group.setAttribute("id", text);
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

// TODO: Move to geometry.js
function Point(x,y) {
  this.x = x;
  this.y = y;
}
