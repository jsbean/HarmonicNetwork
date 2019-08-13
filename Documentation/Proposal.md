# GENED 1080 Proposal: Harmonic Pathinder

I propose here to develop an interactive audio-visual tool which allows a student to incrementally build sequences of chords whose characteristcs resemble those of the Western Common Practice Era. This work piggy-backs off of the [chord-sequence-chooser](https://github.com/bwetherfield) by ES-25 TF Ben Wetherfield in the Fall of 2018.

The goal for this project is to offer the students a way into understanding the relationships between the harmonies that are inescapable in the sonic landscape of Harvard in 2019.

## Basic Overview

This tool presents a [graph](https://en.wikipedia.org/wiki/Graph_theory)<sup>1</sup> representation of harmonic functions and the movement amongst them. Each node represents a single harmonic function (e.g., `I`, `ii6`, `V7`, etc.) and each edge represents the probability of moving from one to another (e.g., `V -> I` will be very likely while `V -> IV` will be non-existent).

This graph representation is equivalent to a first-order Markov chain, and can be configured either by the tastes of those-in-charge, by values collected in previous research (e.g., in Table 5.8 of this [Harvard Bachelor's thesis](([Harvard Bachelor's Thesis](http://www.people.fas.harvard.edu/~msantill/Mauricio_Santillana/Teaching_files/Michaela_Tracy_thesis_Final.pdf))), [here](https://core.ac.uk/download/pdf/10596809.pdf), or [here](http://kern.ccarh.org/cgi-bin/ksbrowse?l=/users/craig/classical/bach/bhchorale)), or by way of analyzing other music and configuring the graph manually.

Each harmonic function is sonically representable by clicking on the node which represents it visually. A global key center (i.e., fundamental reference pitch) determines the concrete instantiation of the harmonic functions as collections of frequencies.

The student is able to navigate their way through paths in this network in a variety of ways: 

- in **manual** mode, the students chooses the next chord from the available options
- in **automatic** mode, the program takes paths determined by the probabilities intrinsic to the network
- in **playback** mode, the program demonstrates the paths taken by real-world compositions

A simple underlying model of the tonic-dominant relationship is presented and increasingly rich examples of harmonic sequences are progressively disclosed by extending several axes of complexification: harmonic functions, chord degrees, and inversions.

[1] A set of nodes and the edges that connect them

## Development Roadmap

This is a good deal of work, but it can be split up into several phases, each of which being viable working products in their own right.

### Phase 0:

The product of development phase 0 will be a [command line interface](https://en.wikipedia.org/wiki/Command-line_interface) which repeatedly asks the student to choose from a selection of allowed successive harmonic functions. The probabilities of moving from the current harmonic function to the next will be displayed.

### Phase 1:

The product of development phase 1 will be a bare-bones web-based instantiation of the command line interface produced by development phase 0.

### Phase 2:

The product of development phase 2 will be a graphical interface which displays the nodes and edges. The student will be able progress through a path of nodes by selecting from the constrained set of allowable neighbors.

*The available set of harmonic functions may be somewhat limited in order to reduce complexity of graphical representation.*

### Phase 3:

Development phase 3 will add sonic feedback will be added to product of development phase 2.

### Phase 4:

Development phase 4 will add a minor version and configurable scalability of harmonic functions, chord degrees, and inversions.

### Phase 5:

Development phase 5 will add present chorales and/or music from other repertoires which can be demonstrated by a **playback mode**.

### Phase 6:

Development phase 6 will a circle-of-fifths representation to harmonic progressions, akin to that of the [`makeascale`](https://github.com/hzsteinberg/makeascale) application.

### Phase 7:

Development phase 7 will add a basic western notation view of sequences.

### Phase 8:

Development phase 8 will add basic MusicXML import option.
