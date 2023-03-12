Class {
	#name : #DrsLabelWithBoxTest,
	#superclass : #TestCase,
	#category : #'Roassal3-ExtendedLabels-Tests'
}

{ #category : #initialization }
DrsLabelWithBoxTest >> inspect: aCanvas [ 

	"aCanvas inspect."
	

]

{ #category : #initialization }
DrsLabelWithBoxTest >> setUp [ 

	super setUp.
	
	RSMetricsProvider default: RSCairoCachedMetricsProvider new. 
	
	Smalltalk os isWindows ifFalse: [ self skip ].

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testAdjustShapeExtents [

	| aText aStyleSheet label c composite origExtent |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #FF0000;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.

	label prepare.
	
	origExtent :=  label bounds innerExtent.
	label bounds innerExtent: (origExtent x // 4) @ origExtent y.
	
	composite := label labelShape.
	
"	self assert: composite extent asIntegerPoint equals: (173@27).
"	
	label adaptShapeExtents.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
 	self assert: composite extent asIntegerPoint equals: (59@27)
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testAdjustShapeExtentsWithBorder [

	| aText aStyleSheet label c composite origExtent |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #FF0000;
	borderWidth: 20;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.

	label prepare.
	
	origExtent :=  label bounds innerExtent.
	label bounds innerExtent: (origExtent x // 4) @ origExtent y.
	
	composite := label labelShape.
	
	self assert: composite extent asIntegerPoint equals: (193@47).
	
	label adaptShapeExtents.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
 	self assert: composite extent asIntegerPoint equals: (78@47)
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testBorderWidth [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #FF0000;
	borderColor: #0F0F0F;
	borderWidth: 40;	
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	
	label prepare.
	
	composite := label labelShape.
		label adaptShapeExtents.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals:{(213@67). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(0@0). (0@0)}.

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights01 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.

	label prepare.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

 	self assert: label labelShape extent asIntegerPoint equals: (173@27)
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights02 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	padding-left: 50;
	padding-top: 50;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.

	label prepare.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :each | self assert: each position asIntegerPoint equals: (10@25)  ].


]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights03 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBB77;
	padding-left: 50;
	padding-top: 50;
	
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.
	
	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label iconShape: DrsExtendedIcon exampleIcon.

	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :each | self assert: each position asIntegerPoint equals: (18@25)  ].
	


]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights04 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	padding-left: 0;
	padding-top: 0;
	iconOffset: 0;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label iconShape: DrsExtendedIcon exampleIcon.

	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(189@27). (24@16). (37@27). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(4@0). (-86@ -5). (-2@0). (11@0)}
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights05 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	padding-left: 0;
	padding-top: 0;
	iconOffset: 0;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.


	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(37@27). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals:{(-14@0). (0@0)}.

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights06 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	padding-left: 20;
	padding-top: 0;
	iconOffset: 0;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label iconShape: DrsExtendedIcon exampleIcon.

	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(209@27). (24@16). (37@27). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(0@0). (-80@ -5). (3@0). (17@0)}

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights07 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	padding-left: 0;
	padding-top: 0;
	iconOffset: 10;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label iconShape: DrsExtendedIcon exampleIcon.

	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(199@27). (24@16). (37@27). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(4@0). (-91@ -5). (2@0). (16@0)}
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights08 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	padding-left: 10;
	padding-top: 20;
	iconOffset: 10;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label iconShape: DrsExtendedIcon exampleIcon.

	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(209@47). (24@16). (37@27). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(0@0). (-90@4). (3@10). (17@9)}

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights09 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	borderWidth: 100;
	borderColor: #FF0000;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label iconShape: DrsExtendedIcon exampleIcon.

	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(289@127). (24@16). (37@27). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(0@0). (-90@ -5). (-6@0). (8@0)}

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights10 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	borderWidth: 2;
	borderColor: #FF0000;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label iconShape: DrsExtendedIcon exampleIcon.

	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(191@29). (24@16). (37@27). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(3@0). (-87@ -5). (-3@0). (11@0)}

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights11 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	borderWidth: 1;
	padding-left: 2;
	iconOffset: 2;
	borderColor: #FF0000;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label iconShape: DrsExtendedIcon exampleIcon.

	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(194@28). (24@16). (37@27). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(2@0). (-87@ -5). (-1@0). (12@0)}
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights12 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	wrapping: 1;
}
	'.

	aText := PdmText string: 'Some very long text. Some very long text. Some very long text. Some very long text. Some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.

	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(300@108). (283@26). (273@26). (283@26). (37@27). (37@27). (37@27). (37@27).
(37@27). (78@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(0@0). (-8@ -40). (-13@ -13). (-8@13). (-75@ -40). (109@ -40). (12@ -13).
(-75@13). (109@13). (-110@40)}

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights13 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	wrapping: 1;
}
	'.

	aText := PdmText string: 'Some very long text. Some very long text. Some very long text. Some very long text. Some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label iconShape: DrsExtendedIcon exampleIcon.

	label prepare.
	label adaptSublables.
	
"	label highlightText: 'very' emphasized: true.
"	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(316@108). (24@16). (283@26). (273@26). (283@26). (78@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals:{(4@0). (-150@ -46). (3@ -40). (-1@ -13). (3@13). (-98@40)}
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights14 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	wrapping: 1;
	iconOffset: 100;
}
	'.

	aText := PdmText string: 'Some very long text. Some very long text. Some very long text. Some very long text. Some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label iconShape: DrsExtendedIcon exampleIcon.

	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(416@108). (24@16). (283@26). (273@26). (283@26). (37@27). (37@27). (37@27).
(37@27). (37@27). (78@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(4@0). (-200@ -46). (53@ -40). (48@ -13). (53@13). (-13@ -40). (171@ -40). (74@
-13). (-13@13). (171@13). (-48@40)}
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testHighlights15 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #BBBBBBEE;
	wrapping: 1;
	iconOffset: 50;	
	padding-top: 20;
	padding-left: 20;
}
	'.

	aText := PdmText string: 'Some very long text. Some very long text. Some very long text. Some very long text. Some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label iconShape: DrsExtendedIcon exampleIcon.

	label prepare.
	label adaptSublables.
	
	label highlightText: 'very' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(386@128). (24@16). (283@26). (273@26). (283@26). (37@27). (37@27). (37@27).
(37@27). (37@27). (78@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(0@0). (-169@ -36). (34@ -30). (29@ -3). (34@23). (-32@ -30). (152@ -30). (55@
-3). (-32@23). (152@23). (-67@50)}
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testMultiLine [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #FF0000;
}
	'.

	aText := PdmText string: 'Some very long text. Some very long text. Some very long text. Some very long text. Some very long text. ' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 

	label prepare.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: composite extent asIntegerPoint equals: (300@108)
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testMultiLineAdjusted [

	"self skip"

	| aText aStyleSheet label c composite origExtent |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #FF0000;
}
	'.

	aText := PdmText string: 'Some very long text. Some very long text. Some very long text. Some very long text. Some very long text. ' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 

	label prepare.
	
	origExtent := label bounds innerExtent.
	label bounds innerExtent: 150@origExtent y.
	label adaptShapeExtents.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
"	self assert: composite extent asIntegerPoint equals: (278@108)"
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testMultiLineFromCss [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	wrapping: 1;
	fillColor: #FF0000;
}
	'.

	aText := PdmText string: 'Some very long text. Some very long text. Some very long text. Some very long text. Some very long text. ' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.

	label prepare.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: composite extent asIntegerPoint equals: (300@108)
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testNormalSize [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	fillColor: #FF0000;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.

	label prepare.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

 	self assert: label labelShape extent asIntegerPoint equals: (173@27)
]

{ #category : #initialization }
DrsLabelWithBoxTest >> testPadding [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	padding-left: 20;
	padding-top: 30;
	fillColor: #FF0000;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	
	label prepare.
	
	composite := label labelShape.
		label adaptShapeExtents.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(193@57). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(0@0). (9@14)}.

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testPadding2 [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	padding-left: 20;
	padding-top: 30;
	padding-right: 10;
	padding-bottom: 15;
	fillColor: #FF0000;	
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	
	label prepare.
	
	composite := label labelShape.
		label adaptShapeExtents.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(203@72). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(0@0). (4@7)}.

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testPaddingWithBorder [


	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	padding-left: 20;
	padding-top: 30;
	padding-right: 10;
	padding-bottom: 15;
	fillColor: #FF0000;
	borderWidth: 50;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	
	label prepare.
	
	composite := label labelShape.
		label adaptShapeExtents.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(253@122). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(0@0). (5@7)}.
	
	self assert: label assignedExtent asIntegerPoint equals: (303@172)

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testPaddingWithBorderAndRadius [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	padding-left: 20;
	padding-top: 30;
	padding-right: 10;
	padding-bottom: 15;
	fillColor: #FF0000;
	borderWidth: 50;
	cornerRadius: 20;
}
	'.

	aText := PdmText string: 'some very long text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.
	
	label prepare.
	
	composite := label labelShape.
		label adaptShapeExtents.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	self assertCollection: (label labelShape shapes collect: [ :each | each extent asIntegerPoint ]) asArray equals: {(253@122). (173@26)}.
	self assertCollection: (label labelShape shapes collect: [ :each | each position asIntegerPoint ]) asArray equals: {(0@0). (5@7)}.
	
	self assert: label assignedExtent asIntegerPoint equals: (303@172)

]

{ #category : #initialization }
DrsLabelWithBoxTest >> testTextSizes [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
	fillColor: #FF0000;
}
	'.

	aText := PdmText string: 'some text' style: #normal.

	label := DrsLabelWithBox text: aText styleSheet: aStyleSheet.

	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	self assert: label labelShape extent asIntegerPoint equals: 115 @ 27
]
