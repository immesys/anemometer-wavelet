# Mr. Plotter Layouts Library

While the Mr. Plotter QML repository (SoftwareDefinedBuildings/mr-plotter-qml) provides QML components, implemented in C++, for the plotter, the QML interface is rather low-level. This is useful because it is highly customizable; however, it can be cumbersome for an application developer who simply wants to "drop in" a plot.

In this repository are a series of preset QML Layouts for Mr. Plotter that allow a user to include a plot by placing a single QML component, that already contains the "glue" for positioning the plot area, axis area, etc., into his or her application. Hopefully this will ease application development by making it easy to create plots with commonly-used layouts.

If you need a more customizable layout than the ones provided in this repository, you can import MrPlotter directly (see SoftwareDefinedBuildings/mr-plotter-qml) and use the low-level components.

## How to Import this Library

To import this library for use in a Wavelet Application, clone this repository into the src directory of the wavelet. You may then import it as follows:
```
import "mr-plotter-layouts" as MrPlotterLayouts
```

Importing the basic Mr. Plotter QML library with the basic QML types implemented in C++ is done as follows:
```
import MrPlotter 0.1
```

QML components defined in this library need to be prefixed with MrPlotterLayouts. Basic types from the Mr. Plotter QML library can be used directly. The examples below should help clarify this.

## Documentation

Currently, there are three different plotting widgets one can add to an application: Sparkline, BasicPlot, and StandardPlot. To use all of the features of the latter two, there are common classes describing axes and streams and axes, passed as lists to the properties of those widgets.

### Common Classes

#### The Axis Class

The Axis Class is defined in C++ (see mr-plotter-qml/axis.h). These are the properties accessible from QML:
* dynamicAutoscale - If set to true, the axis automatically and dynamically adjusts its scale so that no stream goes out of view in the current time domain
* name - The name of this axis, which is displayed when the axis is rendered
* minTicks - The minimum number of ticks to draw for this axis
* domain - An array of two numbers specifying the range of values displayed by this axis
* streamList - The list of streams that are rendered using this axis
* addStream(s) - Adds the Stream s to this axis. Returns true if the s was added successfully. Returns false if it is already in streamList.
* rmStream(s) - Removes the Stream s from this axis. Returns true if s was removed successfully. Returns false if it is not in streamList.
* domainLo - Same as the first element of the domain array
* domainHi - Same as the second element of the domain array

The default Axis Class changes its appearance abruptly when its domain (or the domainLo and domainHi properties) are reassigned. If you would prefer a smooth transition when the domain is changed, there is a QML type called SmoothYAxis that wraps YAxis and adds an animation when the domain is changed.

#### The Stream Class

The Stream Class is defined in C++ (see mr-plotter-qml/stream.h). These are the properties accessible from QML:
* dataDensity - A boolean indicating whether the values (normal plot) or counts (data density plot) should be used to render this stream
* selected - A boolean indicating whether this stream is in the "selected" state. Selected streams are rendered thicker than streams that are not selected.
* alwaysConnect - Normally, if there is a gap between two points at the resolution at which a stream is viewed, then the gap is shown when the stream is rendered. If there is a single point between two gaps, it is rendered as a point in a scatter plot. If this is set to true, then points are unconditionally connected with lines, regardless of whether there are gaps in the data.
* color - The color with which this stream is rendered
* timeOffset - The time offset with which this stream is rendered (defaults to 0 ns). This allows one to compare a stream to earlier values of that stream. For example, to compare the temperature today to the temparature yesterday, one could set the time domain to start at the beginning of today and to end at the end of today, and plot the stream twice: once with an offset of zero, and again with an offset of +1 day. This property is specified as an array, as follows [milliseconds, nanoseconds], where _nanoseconds_ is a number from 0 to 999999.
* archiver - The URI of the archiver to query to get the data for this stream
* uuid - The UUID of this stream

### Built-In Widgets

#### Sparkline

A _sparkline_ is a lightweight plot that does not feature axes or a data density plot. It is a plot of a single stream, intended as a summary view.

The properties of a Sparkline are:
* uuid - The UUID of the stream to plot
* archiver - The URI of the archiver to query for data
* autozoomOnLoad - Immediately adjusts the time axis to show all of the data when the plot is loaded
* color - The color with which to display the stream
* timeDomain - An array of four numbers describing the start and end of the time axis. The array should look like this: [start time milliseconds, end time milliseconds, start time * nanoseconds, end time nanoseconds]
* scrollZoomable - If true, the user can scroll and zoom to interact with the sparkline. If false, the plot is static.

Example:
```
MrPlotterLayouts.Sparkline {
    uuid: "e14bc2c9-e277-5239-9e60-8fa839394c01"
    archiver: "gabe.ns/s.giles/0/i.archiver"
    autozoomOnLoad: true
    color: "blue"
    scrollZoomable: true

    width: 300
    height: 200
}
```

This element works well in a Grid View. For an example of this, see samkumar99/mrplottergridview.

#### BasicPlot

A _basic plot_ is a plot consisting of:
* A plot area where streams are drawn
* A visible time axis below the plot area
* Visible Y Axes to the left of the plot area

The properties of a BasicPlot are:
* timeDomain - Same as Sparkline
* scrollableDomain - The domain in which the user can scroll the graph. This is useful if you want to allow the user to interact with the graph, but prevent them from scrolling/zooming outside of a certain time range. The range is specified in the same format as timeDomain.
* timeZone - The time zone of the graph
* timeTickPromotion - If set to true, ticks on the time axis are specified in the least granular way possible. For example, supposed the ticks are spaced one-minute apart, and the current time domain includes the beginning of the year 2016. The ticks will read, "... 11:58, 11:59, 2016, 12:01, 12:02 ...". Observe that the "12:00" tick was _promoted_ to "2016". If set to false, this feature is turned off. If you are trying to plot streams with a time offset (for example, to compare two parts of the same stream), it may be desirable to disable Time Tick Promotion
* axisList - A list of Axis objects, specifying the axes that are drawn in the allocated space to the left of the plot area.
* streamList - A list of Stream objects, specifying which streams to draw
* scrollZoomable - Same as Sparkline
* autozoom - A function that takes no arguments that, when invoked, adjusts the time axes to show all of the data. If data needs to be fetched from the archiver, this will operate asynchronously.


#### StandardPlot

A _standard plot_ is a plot consisting of:
* A plot area where streams are drawn
* A visible time axis below the plot area
* Visible Y Axes to the left of the plot area
* Visible Y Axes to the right of the plot area
* A data density plot area above the regular plot area
* Visible Y Axes to the left of the data density plot

The properties of a StandardPlot are:
* timeDomain - Same as Sparkline and BasicPlot
* scrollableDomain - Same as BasicPlot
* timeZone - Same as BasicPlot
* timeTickPromotion - Same as BasicPlot
* leftAxisList - A list of Axis objects, specifying the axes that are drawn in the allocated space to the left of the plot area
* rightAxisList - A list of Axis objects, specifying the axes that are drawn in the allocated space to the right of the plot area
* streamList - Same as BasicPlot
* scrollZoomable - Same as Sparkline and BasicPlot
* leftDataDensityAxisList - A list of Axis objects, specifying the axes that area drawn in the allocated space to the left of the data density plot
* dataDensityStreamList - A list of Stream objects, specifying the streams to plot in the data density plot
* dataDensityScrollZoomable - If set to true, the user can click-and-drag the data density plot to interact with the plot, just as they can do so using the main plot
* autozoom - Same as BasicPlot

Example:
```
import QtQuick 2.6
import QtQuick.Window 2.2
import MrPlotter 0.1
import BOSSWAVE 1.0
import "mr-plotter-layouts" as MrPlotterLayouts

Window {
    visible: true

    Component.onCompleted: {
        mrpbl.autozoom();
    }

    Stream {
        id: s1
        dataDensity: false
        selected: false
        alwaysConnect: false

        color: "blue"
        timeOffset: [0, 0]
        archiver: "gabe.ns/s.giles/0/i.archiver"
        uuid: "e14bc2c9-e277-5239-9e60-8fa839394c01"
    }

    Stream {
        id: s2
        dataDensity: false
        selected: true
        alwaysConnect: true

        color: "red"
        timeOffset: [0, 0]
        archiver: "gabe.ns/s.giles/0/i.archiver"
        uuid: "e1a6abbc-ddbd-50da-896e-b8b27e1d5ff1"
    }

    Stream {
        id: dds1
        dataDensity: true
        selected: false
        alwaysConnect: false

        color: "blue"
        timeOffset: [0, 0]
        archiver: "gabe.ns/s.giles/0/i.archiver"
        uuid: "e14bc2c9-e277-5239-9e60-8fa839394c01"
    }

    MrPlotterLayouts.SmoothYAxis {
        id: a1
        dynamicAutoscale: true
        name: "True Power 1"
        domain: [-2, 2]
        streamList: [s1]
    }

    MrPlotterLayouts.SmoothYAxis {
        id: a2
        dynamicAutoscale: false
        name: "True Power 2"
        domain: [-2, 2]
        streamList: [s2]
        minTicks: 2
    }

    MrPlotterLayouts.SmoothYAxis {
        id: dda1
        dynamicAutoscale: true
        name: "Count"
        domain: [0, 2]
        streamList: [dds1]
    }

    MrPlotterLayouts.StandardPlot {
        id: mrpbl
        anchors.fill: parent
        timeDomain: [1415643674978, 1415643674979, 469055.0, 469060.0]
        timeZone: "America/Los_Angeles"
        timeTickPromotion: true
        leftAxisList: [a1]
        rightAxisList: [a2]
        streamList: [s1, s2]
        scrollZoomable: true
        leftDataDensityAxisList: [dda1]
        dataDensityStreamList: [dds1]
        dataDensityScrollZoomable: false
    }
}
```
