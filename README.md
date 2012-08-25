# README for chart module

## Version

2008-Aug-14: (0.3)
2008-Jun-18: (0.1)

## Overview

This classes in this module work together to construct a model of a graphic visualization of a numeric dataset.

This module does not include any rendering facilities.  The chart model must be passed to some other package to be turned into a visualization.  The intent is for the chart model to include all the information necessary for any particular *static* representation (PNG, PDF, EPS, SVG, AJAX, Flash, etc.) to be created.

By "static" here we mean that the visualization is a closed system; it can't include exploratory facilities that go beyond what's included in the source data, because we don't include outbound links or anything else in the source data that could be used for that purpose.  A rendering engine could include interactive capabilities where appropriate, e.g. zoom, pan, tooltips, display customization.

## Chart Components

* Canvas - describes the background of the plot area as well as the margin area that includes title and axes
* Chron Axis - time-series axis, always horizontal
* Y Axis - value axis, usually vertical
* Layers (at least one)

Chart configuration is through Themes, which are collections of instructions for layout.  Themes include:

* physical rendering dimensions (pixels or other measures) (aspect ratio)
* colors
* fonts
* margins
* hints on axis tick density, margin widths
* placement of tooltips?

## Rendering Options

* Javascript charting, e.g. plotr
* static image generation, e.g. ChartMechanic
* Flash, e.g. amcharts
* Google Visualization API and Google Chart widgets
* R

## Requirements

Each component of the chart must be able to be constructed independently.  This is particularly for testing.

Components may interact with one another, but if the other component is not present there must be graceful degradation.

Examples of component interaction:

* axis could access the canvas to determine physical space available in order to decide whether to show tick labels and how many

## Thoughts

A thumbnail-sized chart is not just a scaled-down version of a large chart.  Thumbnail would generally suggest a sparkline approach, with minimal or hidden axes and other labeling.  A small chart should not be unreadable, it will just have less decoration.
