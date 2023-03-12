Class {
	#name : #DrsLabelTest,
	#superclass : #TestCase,
	#category : #'Roassal3-ExtendedLabels-Tests'
}

{ #category : #private }
DrsLabelTest >> checkShapesOf: aLabel matching: aCollection [

	| composite |
	composite := aLabel labelShape.
	self assert: composite shapes size equals: aCollection size.

	composite shapes with: aCollection do: [ :aShape :expectedText |
		self assert: aShape text equals: expectedText ] 
]

{ #category : #private }
DrsLabelTest >> inspect: anObject [ 

	"anObject inspect."
]

{ #category : #tests }
DrsLabelTest >> setUp [ 

	super setUp.
	
	RSMetricsProvider default: RSCairoCachedMetricsProvider new. 
	
	Smalltalk os isWindows ifFalse: [ self skip ].

]

{ #category : #tests }
DrsLabelTest >> testChangeText [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
}
.small { 
	fontName: "Source Code Pro";
	fontSize: 5;
	textColor: #FF0000;
}
	'.

	aText := PdmText string: 'some text' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label prepare.

	aText := PdmText string: 'new text' style: #smaall.
	label text: aText.
	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	self assert: label labelShape extent asIntegerPoint equals: 47 @ 16
]

{ #category : #tests }
DrsLabelTest >> testCharacterPosition [

	| aText aStyleSheet  label c composite |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz' style: #normal.
	aText addString: 'abcdef' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	composite := label labelShape.	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: (label characterPositionOf: 0 atLine: 1) equals: 1.
	self assert: (label characterPositionOf: 2 atLine: 1) equals: 1.
	self assert: (label characterPositionOf: 12 atLine: 1) equals: 1.
	self assert: (label characterPositionOf: 13 atLine: 1) equals: 2.
	self assert: (label characterPositionOf: 280 atLine: 1) equals: 22.
	self assert: (label characterPositionOf: 282 atLine: 1) equals: 23.
	self assert: (label characterPositionOf: 500 atLine: 1) equals: 23.
	self assert: (label characterPositionOf: 0 atLine: 2) equals: 23.
	self assert: (label characterPositionOf: 12 atLine: 2) equals: 23.
	self assert: (label characterPositionOf: 13 atLine: 2) equals: 24.
	self assert: (label characterPositionOf: 89 atLine: 2) equals: 29.
	self assert: (label characterPositionOf: 90 atLine: 2) equals: 30.
	self assert: (label characterPositionOf: 100 atLine: 2) equals: 31.
	self assert: (label characterPositionOf: 500 atLine: 2) equals: 36.

]

{ #category : #tests }
DrsLabelTest >> testCompositeShapesFrom [

	| aText label composite c aStyleSheet |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 12;
}
.small { 
	fontName: "Source Code Pro";
	fontSize: 5;
	textColor: "red";
}	'.

	aText := PdmText string: 'some_' style: #normal.
	aText addString: 'some' style: #small.
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	composite := label labelShape.

	self
		assertCollection: (composite shapes
				 collect: [ :each | each position asIntegerPoint ]
				 as: Array)
		hasSameElements: { 
				(-8 @ 0).
				(24 @ 3) }.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
]

{ #category : #tests }
DrsLabelTest >> testCompositeShapesFrom2 [

	| styles aStyleSheet string aText label composite c |
	
	styles := (1 to: 40) collect: [ :i | 
		          '.style{1} \{ 
	fontName: "Source Code Pro";
	fontSize: {1};
	textColor: "{2}";
\}' format: { 
				          i.
				          (i odd
					           ifTrue: [ #red ]
					           ifFalse: [ #black ]) } ].

	aStyleSheet := DrsStyleSheet parse: (styles joinUsing: String cr).

	string := 'This is an example text of Baseline _hyŘ' asText.
	string := 'MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM' asText.
	aText := PdmText new.
	1 to: 40 do: [ :i | 
		aText addString: (string at: i) asString style: 'style' , i asString ].

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label prepare.

	composite := label labelShape.
"	composite adjustToChildren.
"
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self
		assertCollection: (composite shapes
				 collect: [ :each | each position asIntegerPoint ]
				 as: Array)
		hasSameElements: {(-327@18). (-326@17). (-324@17). (-321@17). (-318@16). (-313@15). (-308@15).
(-302@14). (-295@14). (-288@14). (-279@13). (-270@13). (-260@12). (-249@12).
(-238@11). (-225@11). (-212@10). (-198@10). (-183@9). (-168@9). (-151@8).
(-134@8). (-116@7). (-97@7). (-78@7). (-57@6). (-36@6). (-14@5). (8@4). (32@4).
(56@4). (81@3). (107@3). (134@2). (162@2). (190@1). (219@1). (249@0). (280@0).
(312@0)}.


]

{ #category : #tests }
DrsLabelTest >> testCompositeShapesFrom3 [

	| aText label composite | 
	
	aText := PdmText string: '' style: #normal.

	label := DrsLabel text: aText. "stub instance"	
	
	label prepare.
	composite := label labelShape.
		
	self assert: composite shapes size equals: 1.
]

{ #category : #tests }
DrsLabelTest >> testCreateEmpty [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
'.

	aText := PdmText style: #normal.
	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: true.

	self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(0@0)}
]

{ #category : #tests }
DrsLabelTest >> testCreateIcon [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
'.

	aText := PdmText style: #normal.
	aText addIcon: DrsBitmap exampleIcon.
	aText addString: 'efg' style: #small.
	aText addString: 'hi' style: #normal.	
		
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: true.

	self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-20@ -5). (-20@ -9). (-4@ -5). (11@ -5)}	
]

{ #category : #tests }
DrsLabelTest >> testCreateIcon2 [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
'.

	aText := PdmText style: #normal.
	aText addString: 'efg' style: #small.
	aText addIcon: DrsBitmap exampleIcon.
	aText addString: 'hi' style: #normal.	
		
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: true.

	self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-20@ -5). (-20@ -5). (-4@ -9). (11@ -5)}
]

{ #category : #tests }
DrsLabelTest >> testCreateIcon3 [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
'.

	aText := PdmText style: #normal.
	aText addString: 'efg' style: #small.
	aText addString: 'hi' style: #normal.	
	aText addIcon: DrsBitmap exampleIcon.
		
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: true.

	self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-20@ -5). (-20@ -5). (-4@ -5). (4@ -9)}
]

{ #category : #tests }
DrsLabelTest >> testCreateIcon4 [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
'.

	aText := PdmText style: #normal.
	aText addString: 'efg' style: #small.
	aText addString: 'hi' style: #normal.	
	aText addIcon: DrsBitmap exampleIcon.
		
	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label visibleLength: 2.

	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: true.

	self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-10@ -7). (-10@ -7)}
]

{ #category : #tests }
DrsLabelTest >> testCreateIcon5 [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
'.

	aText := PdmText style: #normal.
	aText addString: 'efg' style: #small.
	aText addString: 'hi' style: #normal.	
	aText addIcon: DrsBitmap exampleIcon.
		
	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label visibleLength: 4.

	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: true.

	self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-16@ -7). (-16@ -7). (-1@ -7)}
]

{ #category : #tests }
DrsLabelTest >> testCreateIcon6 [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
'.

	aText := PdmText style: #normal.
	aText addString: 'efg' style: #small.
	aText addString: 'hi' style: #normal.	
	aText addIcon: DrsBitmap exampleIcon.
		
	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label visibleLength: 5.

	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: true.

	self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-16@ -5). (-16@ -5). (0@ -5). (8@ -9)}
]

{ #category : #tests }
DrsLabelTest >> testCreateIcon7 [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
	wrapping: 1;
} 
'.

	aText := PdmText style: #normal.
	aText addString: 'efg' style: #small.
	aText addString: 'hi' style: #normal.	
	aText addIcon: DrsBitmap exampleIcon.
		
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: true.

	self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-20@ -5). (-20@ -5). (-4@ -5). (4@ -9)}
]

{ #category : #tests }
DrsLabelTest >> testCreateIcon8 [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
	wrapping: 1;
} 
'.

	aText := PdmText style: #normal.
	aText addString: 'efg' style: #small.
	aText addString: '1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 ' style: #normal.	
	aText addIcon: DrsBitmap exampleIcon.
			
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: true.

	self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-131@ -17). (-131@ -17). (-116@ -17). (-131@2). (54@ -1)}
]

{ #category : #tests }
DrsLabelTest >> testCreateLabelChunks [

	| aText label sublabels aStyleSheet |
	
	aStyleSheet := DrsStyleSheet parse: '
.simpleText { 
	fontName: "Source Code Pro";
	fontSize: 12;
}	'.
	
	aText := PdmText string: 'some text'.
"	aText addAttribute: (TextFontReference toFont: (LogicalFont familyName: 'Source Code Pro' pointSize: 12)).
"
	label := DrsLabel text: aText styleSheet: aStyleSheet. "stub instance"	
	
	sublabels := label labelChunks.
	
	self assert: sublabels size equals: 1.
	
	"self assert: sublabels first fontName equals: 'Source Code Pro'.
	self assert: sublabels first fontSize equals: 12.	"
	"self assert: (sublabels first propertyAt: #baseline) equals: 0."
]

{ #category : #tests }
DrsLabelTest >> testCreateSingle [ 

	| aText label aStyleSheet composite | 
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} '.
	
	aText := PdmText string: 'some text' style: #normal.
	label := DrsLabel text: aText styleSheet: aStyleSheet. 
	label prepare.
	composite := label labelShape.
	
	self assert: composite extent asIntegerPoint equals: (115@26).
]

{ #category : #tests }
DrsLabelTest >> testCursor00 [ 

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label prepare.

	c := RSCanvas new.
	
	label moveCursorAt: 2 canvas: c.

	composite := label labelShape.
	
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint  equals: (-54@0)
			 ].
	
]

{ #category : #tests }
DrsLabelTest >> testCursor01 [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label prepare.
	
	label moveCursorAt: 1.

"	label highlightText: 'h' emphasized: true.
"
	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	"c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1)."
	self inspect: c.
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint equals: (-60@0)
			 ].
	
]

{ #category : #tests }
DrsLabelTest >> testCursor02 [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label prepare.
	
	label moveCursorAt: aText fullLength.
	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint equals: (45@ 0)
	]
]

{ #category : #tests }
DrsLabelTest >> testCursor03 [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label prepare.
	
	label moveCursorAt: aText fullLength + 1.
	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

"	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint equals: (44@ -1)
	]"
]

{ #category : #tests }
DrsLabelTest >> testCursor04 [

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label prepare.
	
	label moveCursorAt: aText fullLength + 1.
	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint equals: (62@0)
	]
]

{ #category : #tests }
DrsLabelTest >> testCursor05 [

	"multiline"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk efghijk efghijk efghijk efghijk efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	label moveCursorAt: 1.
	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint equals: (-125@ -44)
	]
]

{ #category : #tests }
DrsLabelTest >> testCursor06 [

	"multiline"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk efghijk efghijk efghijk efghijk efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	label moveCursorAt: 3.
	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint equals: (-103@ -44)
	]
]

{ #category : #tests }
DrsLabelTest >> testCursor07 [

	"multiline"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk efghijk efghijk efghijk efghijk efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	label moveCursorAt: 3.
	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint equals: (-103@ -44)
	]
]

{ #category : #tests }
DrsLabelTest >> testCursor08 [

	"multiline"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk efghijk efghijk efghijk efghijk efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	label moveCursorAt: 20.
	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint equals: (120@ -44)
	]
]

{ #category : #tests }
DrsLabelTest >> testCursor09 [

	"multiline"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk efghijk efghijk efghijk efghijk efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	label moveCursorAt: 21.
	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint equals: (-125@0)
	]
]

{ #category : #tests }
DrsLabelTest >> testCursor10 [

	"multiline"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk efghijk efghijk efghijk efghijk efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	label moveCursorAt: 52.
	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint equals: (76@44)
	]
]

{ #category : #tests }
DrsLabelTest >> testCursor11 [

	"animation"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk efghijk efghijk efghijk efghijk efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	composite := label labelShape.
	
	c := RSCanvas new.

	label moveCursorAt: 52 canvas: c.

	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	"label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (2.0@44.0).
		self assert: aShape position asIntegerPoint equals: (80@44)
	]"
]

{ #category : #tests }
DrsLabelTest >> testDisplayedLenght [

	| aText aStyleSheet labelChunks |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.

	labelChunks := aText
		               labelChunksWith: aStyleSheet
		               length: aText fullLength.

	self assert: labelChunks size equals: 1.
	self assert: labelChunks first displayedString equals: 'abcd'
]

{ #category : #tests }
DrsLabelTest >> testDisplayedLenghtMoreMultipleChunksShortenedMore [

	| aText aStyleSheet c label composite |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efg' style: #small.
	aText addString: 'hi' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	composite := label labelShape.
	self assert: composite shapes size equals: 3.
	self assert: composite shapes first text equals: 'abcd'.
	self assert: composite shapes second text equals: 'efg'.
	self assert: composite shapes third text equals: 'hi'.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1)
	"c inspect"
	"
	labelChunks := aText labelChunksWith: aStyleSheet length: 8.
	self assert: labelChunks first displayedString equals: 'abcd'.
	self assert: labelChunks second displayedString equals: 'efg'.
	self assert: labelChunks third displayedString equals: 'h…'.

	labelChunks := aText labelChunksWith: aStyleSheet length: 7.
	self assert: labelChunks first displayedString equals: 'abcd'.
	self assert: labelChunks second displayedString equals: 'efg'.
	self assert: labelChunks third displayedString equals: '…'.

	labelChunks := aText labelChunksWith: aStyleSheet length: 6.
	self assert: labelChunks first displayedString equals: 'abcd'.
	self assert: labelChunks second displayedString equals: 'ef…'.
	self assert: labelChunks third displayedString equals: ''.

	labelChunks := aText labelChunksWith: aStyleSheet length: 5.
	self assert: labelChunks first displayedString equals: 'abcd'.
	self assert: labelChunks second displayedString equals: 'e…'.
	self assert: labelChunks third displayedString equals: ''.

	labelChunks := aText labelChunksWith: aStyleSheet length: 4.
	self assert: labelChunks first displayedString equals: 'abcd'.
	self assert: labelChunks second displayedString equals: '…'.
	self assert: labelChunks third displayedString equals: ''.

	labelChunks := aText labelChunksWith: aStyleSheet length: 3.
	self assert: labelChunks first displayedString equals: 'abc…'.
	self assert: labelChunks second displayedString equals: ''.
	self assert: labelChunks third displayedString equals: ''.

	labelChunks := aText labelChunksWith: aStyleSheet length: 2.
	self assert: labelChunks first displayedString equals: 'ab…'.
	self assert: labelChunks second displayedString equals: ''.
	self assert: labelChunks third displayedString equals: ''.

	labelChunks := aText labelChunksWith: aStyleSheet length: 1.
	self assert: labelChunks first displayedString equals: 'a…'.
	self assert: labelChunks second displayedString equals: ''.
	self assert: labelChunks third displayedString equals: ''.

	labelChunks := aText labelChunksWith: aStyleSheet length: 0.
	self assert: labelChunks first displayedString equals: '…'.
	self assert: labelChunks second displayedString equals: ''.
	self assert: labelChunks third displayedString equals: ''"
]

{ #category : #tests }
DrsLabelTest >> testDisplayedLenghtMultipleChunks [

	| aText aStyleSheet labelChunks |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efg' style: #small.

	labelChunks := aText
		               labelChunksWith: aStyleSheet
		               length: aText fullLength.

	self assert: labelChunks size equals: 2.
	self assert: labelChunks first displayedString equals: 'abcd'.
	self assert: labelChunks second displayedString equals: 'efg'
]

{ #category : #tests }
DrsLabelTest >> testDisplayedLenghtMultipleChunksShortened [

	| aText aStyleSheet labelChunks |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efg' style: #small.

	labelChunks := aText labelChunksWith: aStyleSheet length: 6.

	self assert: labelChunks size equals: 2.
	self assert: labelChunks first displayedString equals: 'abcd'.
	self assert: labelChunks second displayedString equals: 'ef…'.
	
	labelChunks := aText labelChunksWith: aStyleSheet length: 5.

	self assert: labelChunks size equals: 2.
	self assert: labelChunks first displayedString equals: 'abcd'.
	self assert: labelChunks second displayedString equals: 'e…'	.

	labelChunks := aText labelChunksWith: aStyleSheet length: 4.

	self assert: labelChunks size equals: 2.
	self assert: labelChunks first displayedString equals: 'abcd'.
	self assert: labelChunks second displayedString equals: '…'
]

{ #category : #tests }
DrsLabelTest >> testDisplayedLenghtMultipleChunksShortenedMore [

	| aText aStyleSheet labelChunks |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efg' style: #small.

	labelChunks := aText labelChunksWith: aStyleSheet length: 3.
	self assert: labelChunks size equals: 1.
	self assert: labelChunks first displayedString equals: 'abc…'.

	labelChunks := aText labelChunksWith: aStyleSheet length: 1.
	self assert: labelChunks size equals: 1.
	self assert: labelChunks first displayedString equals: 'a…'.

	labelChunks := aText labelChunksWith: aStyleSheet length: 0.
	self assert: labelChunks size equals: 1.
	self assert: labelChunks first displayedString equals: '…'.
]

{ #category : #tests }
DrsLabelTest >> testDisplayedLenghtShortened [

	| aText aStyleSheet labelChunks |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.

	labelChunks := aText labelChunksWith: aStyleSheet length: 3.
	self assert: labelChunks size equals: 1.
	self assert: labelChunks first length equals: 3.
	self assert: labelChunks first displayedString equals: 'abc…'.

	labelChunks := aText labelChunksWith: aStyleSheet length: 1.
	self assert: labelChunks size equals: 1.
	self assert: labelChunks first length equals: 1.
	self assert: labelChunks first displayedString equals: 'a…'.

	labelChunks := aText labelChunksWith: aStyleSheet length: 0.
	self assert: labelChunks size equals: 1.
	self assert: labelChunks first length equals: 0.
	self assert: labelChunks first displayedString equals: '…'
]

{ #category : #tests }
DrsLabelTest >> testDisplayedText [

	| aText label aStyleSheet |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 12;
}
.small { 
	fontName: "Source Code Pro";
	fontSize: 5;
	textColor: "red";
}	'.

	aText := PdmText string: 'some_' style: #normal.
	aText addString: 'some' style: #small.
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	self assert: label visibleLength equals: 9.

	label visibleLength: 6.
		
	self assert: label displayedText equals: 'some_s'
	
	
]

{ #category : #tests }
DrsLabelTest >> testEnsureCharacterPositions [

	| aText label composite positions aStyleSheet c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.red { 
	fontName: "Source Sans Pro";
	fontSize: 16;
	textColor: "red";
}
'.

	aText := PdmText string: 'M' style: #normal.
	aText addString: 'M' style: #red.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	positions := label ensureCharacterPositions.

	label prepare.
	composite := label labelShape.
	
	self
		assertCollection: (composite shapes
				 collect: [ :each | each position asIntegerPoint ]
				 as: Array)
		hasSameElements: {(-7@0). (7@0)}.

	c := RSCanvas new.
	composite translateTo: composite extent x half @ 0.
	c addShape: composite.

	positions do: [ :aPosition | 
		c addShape: (RSBox new
				 extent: 1 @ 250;
				 color: Color blue;
				 translateTo: aPosition @ 0;
				 yourself) ]

	"	c inspect"

]

{ #category : #tests }
DrsLabelTest >> testEnsureCharacterPositionsEmpty [

	| aText label positions aStyleSheet |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
'.

	aText := PdmText string: '' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	positions := label ensureCharacterPositions.
	self
		assertCollection:
		(positions collect: [ :each | each round: 2 ]) asArray
		hasSameElements: #( 0 )
]

{ #category : #tests }
DrsLabelTest >> testEnsureCharacterPositionsSingle [

	| aText label composite positions aStyleSheet c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
'.

	aText := PdmText string: 'mmmmmmmm' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	positions := label ensureCharacterPositions.
	self
		assertCollection:
		(positions collect: [ :each | each round: 2 ]) asArray
		hasSameElements:
		#( 0.00 17.69 35.37 53.06 70.74 88.43 106.11 123.80 141.48 ).

	label prepare.
	composite := label labelShape.

	self
		assertCollection: (composite shapes
				 collect: [ :each | each position asIntegerPoint ]
				 as: Array)
		hasSameElements: { (0 @ 0) }.


	c := RSCanvas new.
	composite translateTo: composite extent x half @ 0.
	c addShape: composite.

	positions do: [ :aPosition | 
		c addShape: (RSBox new
				 extent: 1 @ 250;
				 color: Color blue;
				 translateTo: aPosition @ 0;
				 yourself) ]

	"c inspect"
]

{ #category : #tests }
DrsLabelTest >> testExpandIconWidth [

	| aText aStyleSheet label |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
	wrapping: 1;
	expandable: 1;
	expanded: 1;
} 
'.

	aText := PdmText style: #normal.
	self assert: aText expandIconSpace equals: 16.
	
]

{ #category : #tests }
DrsLabelTest >> testExpandable01 [

	| aText aStyleSheet label |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
	wrapping: 1;
	expandable: 1
} 
'.

	aText := PdmText style: #normal.
	label := DrsLabel text: aText styleSheet: aStyleSheet.
	self assert: label expandable.
	self deny: label expanded.

]

{ #category : #tests }
DrsLabelTest >> testExpandable02 [

	| aText aStyleSheet label composite c |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
	wrapping: 1;
	expandable: 1;
	expanded: 1;
} 
'.

	aText := PdmText style: #normal.
	aText addString: 'abc' style: #normal.
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	self assert: label expandable.
	self assert: label expanded.

	label prepare.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection:(((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements:{(-24@ -7). (-24@ -7). (-1@ -4). (14@ -5)}
]

{ #category : #tests }
DrsLabelTest >> testExpandable03 [

	| aText aStyleSheet label composite c |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
	wrapping: 1;
	expandable: 1;
	expanded: 1;
} 
'.

	aText := PdmText style: #normal.
	aText addString: '1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 ' style: #normal.
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	self assert: label expandable.
	self assert: label expanded.

	label prepare.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection:(((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-124@ -23). (-124@ -23). (-124@ -7). (-124@8). (66@11). (82@10)}
]

{ #category : #tests }
DrsLabelTest >> testExpandable04 [

	| aText aStyleSheet label composite c |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 12;
	wrapping: 1;
	linesScaling: 0.5;
	expandable: 1;
	expanded: 1;
} 
'.

	aText := PdmText style: #normal.
	aText addString: '1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 ' style: #normal.
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	self assert: label expandable.
	self assert: label expanded.

	label prepare.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection:(((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-144@ -20). (-144@ -20). (-144@0). (-144@10). (-99@9). (-83@8)}
]

{ #category : #tests }
DrsLabelTest >> testExpandable05 [

	| aText aStyleSheet label composite c |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 12;
	wrapping: 1;
	linesScaling: 0.5;
	expandable: 1;
	expanded: 0;
} 
'.

	aText := PdmText style: #normal.
	aText addString: '1234567890 123456789012345678901234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 ' style: #normal.
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	self assert: label expandable.
	self deny: label expanded.

	label prepare.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection:(((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-51@ -10). (-51@ -10). (35@ -3)}
]

{ #category : #tests }
DrsLabelTest >> testExpandable06 [

	| aText aStyleSheet label composite c |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 12;
	wrapping: 1;
	linesScaling: 0.5;
	expandable: 1;
	expanded: 0;
} 
'.

	aText := PdmText style: #normal.
	aText addString: '12 34 56 78 90 12 34 56 78 90 12 34 56 78 90 12 34 56 78 90 12 34 56 78 90 12 34 56 78 90 12 34 56 78 90 12 34 56 78 90 ' style: #normal.
	label := DrsLabel text: aText styleSheet: aStyleSheet.

	self assert: label expandable.
	self deny: label expanded.

	label prepare.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection:(((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-153@ -10). (-153@ -10). (137@ -3)}
]

{ #category : #tests }
DrsLabelTest >> testFirstCharacterOfLine [

	| aText aStyleSheet  label c composite |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz' style: #normal.
	aText addString: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	composite := label labelShape.	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: (label firstCharacterOfLine: 1) equals: 1.
	self assert: (label firstCharacterOfLine: 2) equals: 23.
	self assert: (label firstCharacterOfLine: 3) equals: 52.
		
	

]

{ #category : #tests }
DrsLabelTest >> testHighlights0 [

	"test multiple visible highlights"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label visibleLength: 8.

	label prepare.

	label highlightText: 'h' emphasized: true.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (18.858666666666664@44.0).
		self assert: aShape position equals: (18.370666666666665@0.0)
			 ].
	
]

{ #category : #tests }
DrsLabelTest >> testHighlights01 [

	"tests highlight in one text chunk"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efg' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	label highlightText: 'abc' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: 32.27733333333333@27.0.
		self assert: aShape position equals: (-16.256@0)
			 ].
	
]

{ #category : #tests }
DrsLabelTest >> testHighlights02 [

	"tests highlight in multiple chunks"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efg' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	label highlightText: 'abcdef' emphasized: true.
	
	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (56.72533333333334@27.0).
		self assert: aShape position equals: (-4.0319999999999965@0)
			 ].
	
]

{ #category : #tests }
DrsLabelTest >> testHighlights03 [

	"tests highliht in multiple chunks with a big font difference"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	label highlightText: 'cdefg' emphasized: true.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (56.92133333333334@44.0).
		self assert: aShape position equals: (-20.212666666666664@0)
			 ].
	
]

{ #category : #tests }
DrsLabelTest >> testHighlights04 [

	"test shirnked text, highlight in visible part"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label visibleLength: 8.

	label prepare.


	label highlightText: 'cdefg' emphasized: true.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals:(56.92133333333334@44.0).
		self assert: aShape position equals: (-19.519333333333336@0.0)
			 ].
	
]

{ #category : #tests }
DrsLabelTest >> testHighlights05 [

	"highlighting text not found"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label visibleLength: 8.

	label prepare.

	label highlightText: 'cdefgz' emphasized: true.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: label highlightShapes isEmpty.
	
]

{ #category : #tests }
DrsLabelTest >> testHighlights06 [

	"highlighting laast character before ellipsis"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efabijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label visibleLength: 8.

	label prepare.


	label highlightText: 'ab' emphasized: true.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: label highlightShapes size equals: 2.
	
	self assert: label highlightShapes first extent equals: (12.683999999999997@44.0).
	self assert: label highlightShapes first position equals: (-54.477999999999994@0.0).
	self assert: label highlightShapes second extent equals: (36.64266666666666@44.0).
	self assert: label highlightShapes second position equals: (9.634666666666671@0.0)
]

{ #category : #tests }
DrsLabelTest >> testHighlights07 [

	"test multiple visible highlights"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label visibleLength: 8.

	label prepare.

	label highlightText: 'h' emphasized: true.
	
	self assert: label bounds innerExtent equals: label naturalLabelExtent.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	label highlightShapesDo: [ :aShape |
		self assert: aShape extent equals: (18.858666666666664@44.0).
		self assert: aShape position equals: (18.370666666666665@0.0)
			 ].
	
]

{ #category : #tests }
DrsLabelTest >> testHighlights08 [

	"highlighting last character plus the first invisible"

	| aText aStyleSheet label composite c  |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label visibleLength: 8.

	label prepare.

	label highlightText: 'hi' emphasized: true.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: label highlightShapes size equals: 1.
	
 	self assert: label highlightShapes first extent equals:(51.72266666666667@44.0).
	self assert: label highlightShapes first position equals: (34.80266666666667@0.0)

]

{ #category : #tests }
DrsLabelTest >> testHighlights09 [

	"highlighting first invisible character"

	| aText aStyleSheet label composite c  |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label visibleLength: 8.

	label prepare.

	label highlightText: 'j' emphasized: true.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: label highlightShapes size equals: 1.
	
	self assert: label highlightShapes first extent equals: (32.864000000000004@44.0).
	self assert: label highlightShapes first position equals: (44.232@0.0)
	
]

{ #category : #tests }
DrsLabelTest >> testHighlights10 [

	"highlighting two invisible zones"

	| aText aStyleSheet label composite c  |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijkjk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label visibleLength: 8.

	label prepare.

	label highlightText: 'jk' emphasized: true.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: (label highlightShapes select: [ :each | each visible ]) size equals: 1.
	
	self assert: label highlightShapes first extent equals: (32.864000000000004@44.0).
	self assert: label highlightShapes first position equals: (44.232@0.0)
]

{ #category : #tests }
DrsLabelTest >> testHighlights11 [

	"highlighting two zones, one partially visible, second one invisible"

	| aText aStyleSheet label composite c  |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijkjkhi' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label visibleLength: 8.

	label prepare.

	label highlightText: 'hi' emphasized: true.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: (label highlightShapes select: [ :each | each visible ]) size equals: 1.
	
	self assert: label highlightShapes first extent equals: (51.72266666666667@44.0).
	self assert: label highlightShapes first position equals: (34.80266666666667@0.0)
]

{ #category : #tests }
DrsLabelTest >> testHighlights12 [

	"highlighting two zones, one partially visible, second one invisible"

	| aText aStyleSheet label composite c  |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijkjkhi' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label visibleLength: 8.

	label prepare.

	label highlightText: 'hi' emphasized: true.
	
	label removeHighlights.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: (label highlightShapes select: [ :each | each visible ]) size equals: 0.
	
]

{ #category : #tests }
DrsLabelTest >> testInitialLabelAttributes [

	"test if the text attributes in the label are set"

	| label aChunk |
	label := DrsLabel text: (PdmText string: 'some text').
	self assert: label text chunks size equals: 1.
	aChunk := label text chunks first.
	self assert: (aChunk styleClassNames isEmpty).
]

{ #category : #tests }
DrsLabelTest >> testLabelChunksEmpty [

	| aText label labelChunks aStyleSheet |
	
	aStyleSheet := DrsStyleSheet new.
	
	aText := PdmText string: ''.
	label := DrsLabel text: aText styleSheet: aStyleSheet. 
	
	labelChunks := label labelChunks.
	
	self assert: label labelChunks size equals: 1.
	self assert: label labelChunks first text equals: ''.
	self assert: label labelChunks first fontSize equals: 10.
	self assert: label labelChunks first fontName equals: 'Source Sans Pro'.
]

{ #category : #tests }
DrsLabelTest >> testLinesScaling01 [

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 32;
	linesScaling: 0.5;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 20compose
} 
'.

	aText := PdmText string: 'ŘgŽc def ghi Řgkl mno pqrs tuv wxyz abc def ghi jkl mno pqrs tuv wxyz abc def ghi jkl mno pqrs' style: #normal.
	aText addString: 'DEF ABC DEF GHI JKL MNO PQR STU VWX YZ' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.

	label highlightText: 'Ž' emphasized: false.	
	label highlightText: 'Ř' emphasized: true.	
	label highlightText: 'mno pqrs tuv' emphasized: false.	
	
	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection:(((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-144@ -94). (-144@ -39). (-144@ -11). (-144@15). (-144@43). (112@51). (-92@
-96). (-144@ -96). (-92@ -41). (-28@ -41). (-144@13). (-144@78)}
]

{ #category : #tests }
DrsLabelTest >> testMultiLine01 [

	| aText aStyleSheet labelChunks |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs' style: #normal.

	labelChunks := DrsLabel new labelChunksWrappedFrom: aText with: aStyleSheet maxWidth: nil.
		
	self assert: labelChunks	size equals: 4.
	self assert: (labelChunks at: 1) trimmedText equals: 'abcdef ghijkl mnopqrs'.
	self assert: (labelChunks at: 1) lineIndex equals: 1.
	self assert: (labelChunks at: 2) trimmedText equals: 'tuvwxyz abcdef ghijkl'.
	self assert: (labelChunks at: 2) lineIndex equals: 2.
	self assert: (labelChunks at: 3) trimmedText equals: 'mnopqrs tuvwxyz abcdef'.
	self assert: (labelChunks at: 3) lineIndex equals: 3.
	self assert: (labelChunks at: 4) trimmedText equals: 'ghijkl mnopqrs'.
	self assert: (labelChunks at: 4) lineIndex equals: 4.
		
]

{ #category : #tests }
DrsLabelTest >> testMultiLine01b [

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: label wrappingEnabled.
	
	self assertCollection: (((c shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-147@ -53). (0@ -50). (-50@0)}
]

{ #category : #tests }
DrsLabelTest >> testMultiLine02 [

	| aText aStyleSheet labelChunks |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz' style: #normal.
	aText addString: 'abcdef' style: #small.

	labelChunks :=  DrsLabel new
		               labelChunksWrappedFrom: aText with: aStyleSheet maxWidth: nil.
		
	self assert: labelChunks	size equals: 3.
	self assert: (labelChunks at: 1) trimmedText equals: 'abcdef ghijkl mnopqrs'.
	self assert: (labelChunks at: 1) lineIndex equals: 1.
	self assert: (labelChunks at: 2) trimmedText equals: 'tuvwxyz'.
	self assert: (labelChunks at: 2) lineIndex equals: 2.
	self assert: (labelChunks at: 3) trimmedText equals: 'abcdef'.
	self assert: (labelChunks at: 3) lineIndex equals: 2.
]

{ #category : #tests }
DrsLabelTest >> testMultiLine02b [

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz' style: #normal.
	aText addString: 'abcdef' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.

	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	
]

{ #category : #tests }
DrsLabelTest >> testMultiLine03 [

	| aText aStyleSheet  labelChunks |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abc' style: #normal.
	aText addString: 'def' style: #small.

	labelChunks :=  DrsLabel new 
		               labelChunksWrappedFrom: aText with: aStyleSheet maxWidth: nil.
		
	self assert: labelChunks	size equals: 2.
	self assert: (labelChunks at: 1) text equals: 'abc'.
	self assert: (labelChunks at: 1) lineIndex equals: 1.
	self assert: (labelChunks at: 2) text equals: 'def'.
	self assert: (labelChunks at: 2) lineIndex equals: 1.

]

{ #category : #tests }
DrsLabelTest >> testMultiLine03b [

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs' style: #normal.
	aText addString: 'DEF' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	
]

{ #category : #tests }
DrsLabelTest >> testMultiLine03c [ 

	"different max width"

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
	maxLineWidth: 600;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs' style: #normal.
	aText addString: 'DEF' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	
]

{ #category : #tests }
DrsLabelTest >> testMultiLine04b [

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs' style: #normal.
	aText addString: 'DEF ABC DEF GHI JKL MNO PQR STU VWX YZ' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.

	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 300 @ 1).
	self inspect: c.
	
	self assertCollection:(((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-153@ -66). (-153@ -39). (-153@ -12). (-153@14). (25@22). (-153@49)}
]

{ #category : #tests }
DrsLabelTest >> testMultiLine05 [

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.

	label highlightText: 'pqrs' emphasized: true.	
	label highlightText: 'abc' emphasized: false.	
	
	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection:(((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-147@ -53). (-147@ -26). (-147@0). (70@ -54). (-108@0). (-19@27). (-147@ -54).
(-44@ -27). (57@0). (-147@27)}
]

{ #category : #tests }
DrsLabelTest >> testMultiLine06 [

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.

	label highlightText: 'kl mnop' emphasized: true.	
	label highlightText: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs' emphasized: false.	
	
	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-147@ -53). (-147@ -26). (-147@0). (-6@ -54). (96@ -27). (-147@0). (-96@27).
(-147@ -54). (-147@ -27). (-147@0). (-147@27). (-147@27)}
]

{ #category : #tests }
DrsLabelTest >> testMultiLine07 [

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs' style: #normal.
	aText addString: 'DEF ABC DEF GHI JKL MNO PQR STU VWX YZ' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.

	label highlightText: 'kl mnop' emphasized: true.	
	label highlightText: 'GHI JK' emphasized: true.	
	label highlightText: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrsDEF ABC DEF GHI JKL MNO PQR STU VWX YZ' emphasized: false.	
	
	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-153@ -66). (-153@ -39). (-153@ -12). (-153@14). (25@22). (-12@ -67). (89@
-40). (-153@ -13). (-102@13). (121@13). (-153@40). (-153@ -67). (-153@ -40).
(-153@ -13). (-153@13). (-153@40). (-153@49)}
]

{ #category : #tests }
DrsLabelTest >> testMultiLine08 [

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
'.

	aText := PdmText string: ' ABC' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: false. 
	label prepare.
	label highlightText: 'ABC' emphasized: true.
	
	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	"self assertCollection: (((c shapes first shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-153@ -66). (-153@ -39). (-153@ -12). (-153@14). (25@22). (-12@ -67). (89@
-40). (-153@ -13). (-102@13). (121@13). (-153@40). (-153@ -67). (-153@ -40).
(-153@ -13). (-153@13). (-153@40). (-153@49)}"
]

{ #category : #tests }
DrsLabelTest >> testMultiLineCenter01 [

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label horizontalAlignment: #center.
	label prepare.
	
	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: label wrappingEnabled.
	
	self assertCollection: (((c shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-147@ -53). (0@ -50). (-50@0)}
]

{ #category : #tests }
DrsLabelTest >> testMultiLineRight01 [

	| aText aStyleSheet  label c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label horizontalAlignment: #right.
	label wrappingEnabled: true. 
	label prepare.
	
	c := RSCanvas new.
	c addShape: label roassalShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: label wrappingEnabled.
	
	self assertCollection: (((c shapes collect: #topLeftCornerPosition)) collect: #asIntegerPoint as: Array) hasSameElements: {(-147@ -53). (0@ -50). (-50@0)}
]

{ #category : #tests }
DrsLabelTest >> testNaturalExtent [

	| aText aStyleSheet c label extent |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'abcd' style: #small.
	aText addString: 'efg' style: #normal.
	aText addString: 'hi' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	extent := label naturalLabelExtent.
	
	self assert: extent equals: label naturalInnerExtent.

	self
		assert: (label naturalLabelExtent asFloatPoint roundTo: 0.01)
		equals: 73.29 @ 27.

	c := RSCanvas new.
	c addShape: label labelShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	c addShape: (RSBox new
			 extent: 1 @ 100;
			 translateTo: extent half x @ 0;
			 yourself).
	c addShape: (RSBox new
			 extent: 1 @ 100;
			 translateTo: extent half negated x @ 0;
			 yourself).
	c addShape: (RSBox new
			 extent: 100 @ 1;
			 translateTo: 0 @ extent half y;
			 yourself).
	c addShape: (RSBox new
			 extent: 100 @ 1;
			 translateTo: 0 @ extent half negated y;
			 yourself).
]

{ #category : #tests }
DrsLabelTest >> testPrintOn [

	| aText aStyleSheet label |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijkjkhi' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	
	label prepare.
	
	self assert: label asString equals: 'a DrsLabel(abcdefghijkjkhi)'
]

{ #category : #tests }
DrsLabelTest >> testShortenedShapes [

	| aText aStyleSheet c label |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efg' style: #small.
	aText addString: 'hi' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	label visibleLength: 9.
	label privAdaptSublables .
	self checkShapesOf: label matching: #( 'abcd' 'efg' 'hi' ).

	label visibleLength: 8.
	label privAdaptSublables.
	self checkShapesOf: label matching: #( 'abcd' 'efg' 'h…' ).

	label visibleLength: 7.
	label privAdaptSublables.
	self checkShapesOf: label matching: #( 'abcd' 'efg' '…' ).

	label visibleLength: 6.
	label privAdaptSublables.
	self checkShapesOf: label matching: #( 'abcd' 'ef…' ).

	label visibleLength: 5.
	label privAdaptSublables.
	self checkShapesOf: label matching: #( 'abcd' 'e…' ).

	label visibleLength: 4.
	label privAdaptSublables.
	self checkShapesOf: label matching: #( 'abcd' '…' ).

	label visibleLength: 3.
	label privAdaptSublables.
	self checkShapesOf: label matching: #( 'abc…' ).

	label visibleLength: 2.
	label privAdaptSublables.
	self checkShapesOf: label matching: #( 'ab…' ).

	label visibleLength: 1.
	label privAdaptSublables.
	self checkShapesOf: label matching: #( 'a…' ).

	label visibleLength: 0.
	label adaptSublables.
	self checkShapesOf: label matching: #( '…' ).

	c := RSCanvas new.
	c addShape: label labelShape.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1)
	"c inspect"
]

{ #category : #tests }
DrsLabelTest >> testShortenedWidths [

	| aText label shortenedWidths aStyleSheet |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
'.

	aText := PdmText string: 'm' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label ensureCharacterPositions.
	shortenedWidths := label shortenedWidths.

	self
		assertCollection:
		(shortenedWidths collect: [ :each | each round: 2 ]) asArray
		hasSameElements: #( 20.22 37.91 ).

	self
		assert: shortenedWidths first
		equals: label labelChunks first ellipsisWidth.

	self
		assert: ((label shortenedWidthForLength: 0) round: 2)
		equals: 20.22.

]

{ #category : #tests }
DrsLabelTest >> testShortenedWidths2 [

	| aText label shortenedWidths aStyleSheet |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
'.

	aText := PdmText string: 'mi' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label ensureCharacterPositions.
	shortenedWidths := label shortenedWidths.

	self
		assertCollection:
		(shortenedWidths collect: [ :each | each round: 2 ]) asArray
		hasSameElements: #( 20.22 37.91 43.16).

	self
		assert: shortenedWidths first
		equals: label labelChunks first ellipsisWidth.

	self
		assert: ((label shortenedWidthForLength: 0) round: 2)
		equals: 20.22.
	self
		assert: ((label shortenedWidthForLength: 1) round: 2)
		equals: 37.91
]

{ #category : #tests }
DrsLabelTest >> testShortenedWidths3 [

	| aText label shortenedWidths aStyleSheet |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'mi' style: #normal.
	aText addString: 'c' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label ensureCharacterPositions.
	shortenedWidths := label shortenedWidths.

	self
		assertCollection:
		(shortenedWidths collect: [ :each | each round: 2 ]) asArray
		hasSameElements: #( 20.22 37.91 38.1 45.4 ).

	self
		assert: shortenedWidths first
		equals: label labelChunks first ellipsisWidth.

	self
		assert: ((label shortenedWidthForLength: 0) round: 2)
		equals: 20.22.
	self
		assert: ((label shortenedWidthForLength: 1) round: 2)
		equals: 37.91.
	self
		assert: ((label shortenedWidthForLength: 2) round: 2)
		equals: 38.1
]

{ #category : #tests }
DrsLabelTest >> testShortenedWidthsEmpty [

	| aText label shortenedWidths aStyleSheet |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 16;
} 
'.

	aText := PdmText string: '' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label ensureCharacterPositions.
	shortenedWidths := label shortenedWidths.
	self
		assertCollection:
		(shortenedWidths collect: [ :each | each round: 2 ]) asArray
		hasSameElements: #( 20.22 ).

	self
		assert: shortenedWidths first
		equals: label labelChunks first ellipsisWidth
]

{ #category : #tests }
DrsLabelTest >> testSubChunkOfMaxLength [

	| aFontName aFontSize labelChunk subchunk |
	aFontName := 'Source Code Pro'.
	aFontSize := 10.

	labelChunk := DrsLabelCharacterChunk new text: 'ab e gh'.
	labelChunk fontName: aFontName size: aFontSize color: Color black.

	self assert: labelChunk characterPositions equals: #(0 8.0 16.0 24.0 32.0 40.0 48.0 56.0).
	
	subchunk := labelChunk subChunkOfMaxLength: 56.
	self assert: subchunk identicalTo: labelChunk. 

	subchunk := labelChunk subChunkOfMaxLength: 48.
	self assert: subchunk trimmedText equals: 'ab e'.
	
	subchunk := labelChunk subChunkOfMaxLength: 40.
	self assert: subchunk trimmedText equals: 'ab e'.

	subchunk := labelChunk subChunkOfMaxLength: 32.
	self assert: subchunk trimmedText equals: 'ab e'.

	subchunk := labelChunk subChunkOfMaxLength: 31.
	self assert: subchunk trimmedText equals: 'ab'.

	subchunk := labelChunk subChunkOfMaxLength: 24.
	self assert: subchunk trimmedText equals: 'ab'.

	subchunk := labelChunk subChunkOfMaxLength: 16.
	self assert: subchunk trimmedText equals: 'ab'.

	subchunk := labelChunk subChunkOfMaxLength: 8.
	self assert: subchunk trimmedText equals: 'ab'.

	subchunk := labelChunk subChunkOfMaxLength: 0.
	self assert: subchunk trimmedText equals: 'ab'.

]

{ #category : #tests }
DrsLabelTest >> testSubChunkOfMaxLength2 [

	| aFontName aFontSize labelChunk subchunk |
	aFontName := 'Source Code Pro'.
	aFontSize := 10.

	labelChunk := DrsLabelCharacterChunk new text: 'abc fgh'.
	labelChunk fontName: aFontName size: aFontSize color: Color black.

	self assert: labelChunk characterPositions equals: #(0 8.0 16.0 24.0 32.0 40.0 48.0 56.0).
	
	subchunk := labelChunk subChunkOfMaxLength: 56.
	self assert: subchunk identicalTo: labelChunk. 

	subchunk := labelChunk subChunkOfMaxLength: 45.
	self assert: subchunk trimmedText equals: 'abc'. 	

	subchunk := labelChunk subChunkOfMaxLength: 32.
	self assert: subchunk trimmedText equals: 'abc'. 	

	subchunk := labelChunk subChunkOfMaxLength: 31.
	self assert: subchunk trimmedText equals: 'abc'. 	

	subchunk := labelChunk subChunkOfMaxLength: 10.
	self assert: subchunk trimmedText equals: 'abc'. 	
	
]

{ #category : #tests }
DrsLabelTest >> testSubChunkOfMaxLengthFullLenght [

	| aFontName aFontSize labelChunk subchunk |
	aFontName := 'Source Code Pro'.
	aFontSize := 10.

	labelChunk := DrsLabelCharacterChunk new text: 'abcefgh'.
	labelChunk fontName: aFontName size: aFontSize color: Color black.

	self assert: labelChunk characterPositions equals: #(0 8.0 16.0 24.0 32.0 40.0 48.0 56.0).
	
	subchunk := labelChunk subChunkOfMaxLength: 100.
	self assert: subchunk identicalTo: labelChunk. 
	
	subchunk := labelChunk subChunkOfMaxLength: 56.
	self assert: subchunk identicalTo: labelChunk. 

]

{ #category : #tests }
DrsLabelTest >> testSubChunkOfMaxLengthSmallerThanPossible [

	| aFontName aFontSize labelChunk subchunk |
	aFontName := 'Source Code Pro'.
	aFontSize := 10.

	labelChunk := DrsLabelCharacterChunk new text: 'abcefgh'.
	labelChunk fontName: aFontName size: aFontSize color: Color black.

	self assert: labelChunk characterPositions equals: #(0 8.0 16.0 24.0 32.0 40.0 48.0 56.0).
	
	subchunk := labelChunk subChunkOfMaxLength: 55.
	self assert: subchunk text equals: 'abcefgh'. 	

	subchunk := labelChunk subChunkOfMaxLength: 32.
	self assert: subchunk text equals: 'abcefgh'. 	
	
	subchunk := labelChunk subChunkOfMaxLength: 18.
	self assert: subchunk text equals: 'abcefgh'. 	

	subchunk := labelChunk subChunkOfMaxLength: 1.
	self assert: subchunk text equals: 'abcefgh'. 	
		
	subchunk := labelChunk subChunkOfMaxLength: 0.
	self assert: subchunk text equals: 'abcefgh'. 	

]

{ #category : #tests }
DrsLabelTest >> testTextRepresentation [

	"tests highliht in multiple chunks with a big font difference"

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 9;
} 
.small { 
	fontName: "Source Sans Pro";
	fontSize: 26;
} 
'.

	aText := PdmText string: 'abcd' style: #normal.
	aText addString: 'efghijk' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	self assert: label textRepresentation equals:  'abcdefghijk'
]

{ #category : #tests }
DrsLabelTest >> testTextSizes [

	| aText aStyleSheet label c composite |
	
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
}
	'.

	aText := PdmText string: 'some text' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.

	label prepare.

	composite := label labelShape.

	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.

	self assert: label labelShape extent asIntegerPoint equals: 115 @ 26
]

{ #category : #tests }
DrsLabelTest >> testTwoTextChunks [

	| aText label labelChunks aStyleSheet |
	
	aStyleSheet := DrsStyleSheet parse: '
.simpleText { 
	fontName: "Source Sans Pro";
	fontSize: 12;
}

.important { 
	fontName: "Source Code Pro";
	fontSize: 16;
	textColor: #FF0000;
}
'.
	
	aText := PdmText new. 
	aText addString: 'some ' style: 'simpleText'.
	aText addString: 'text' style: 'important'.
	label := DrsLabel text: aText styleSheet: aStyleSheet. 
	
	labelChunks := label sublabels.
	
	self assert: label labelChunks size equals: 2.
	self assert: label labelChunks first text equals: 'some '.
	self assert: label labelChunks first fontSize equals: 12.
	self assert: label labelChunks first fontName equals: 'Source Sans Pro'.
	self assert: label labelChunks first color equals: Color black.
	
	self assert: label labelChunks second text equals: 'text'.
	self assert: label labelChunks second fontSize equals: 16.
	self assert: label labelChunks second fontName equals: 'Source Code Pro'.	
	self assert: label labelChunks second color equals: Color red.

]

{ #category : #tests }
DrsLabelTest >> testWithSingleStyleKnown [

	| aText label labelChunks aStyleSheet |
	
	aStyleSheet := DrsStyleSheet parse: '
.simpleText { 
	fontName: "Source Code Pro";
	fontSize: 12;
}'.
	
	aText := PdmText string: 'some text' style: 'simpleText'.
	label := DrsLabel text: aText styleSheet: aStyleSheet. 
	
	labelChunks := label labelChunks.
	
	self assert: label labelChunks size equals: 1.
	self assert: label labelChunks first text equals: 'some text'.
	self assert: label labelChunks first fontSize equals: 12.
	self assert: label labelChunks first fontName equals: 'Source Code Pro'.
]

{ #category : #tests }
DrsLabelTest >> testWithSingleStyleNotKnown [

	| aText label labelChunks aStyleSheet |
	
	aStyleSheet := DrsStyleSheet parse: '
.simpleText { 
	fontName: "Source Code Pro";
	fontSize: 12;
}	'.
	
	aText := PdmText string: 'some text' style: 'unknownStyle'.
	label := DrsLabel text: aText styleSheet: aStyleSheet. 
	
	labelChunks := label labelChunks.
	
	self assert: label labelChunks size equals: 1.
	self assert: label labelChunks first text equals: 'some text'.
	self assert: label labelChunks first fontSize equals: 10.
	self assert: label labelChunks first fontName equals: 'Source Sans Pro'.
]

{ #category : #tests }
DrsLabelTest >> testWithTwoStyles [

	| aText label labelChunks aStyleSheet |
	
	aStyleSheet := DrsStyleSheet parse: '
.simpleText { 
	fontName: "Source Code Pro";
	fontSize: 12;
}

.bigFont { 
	fontSize: 16;
}
'.
	
	aText := PdmText string: 'some text' styles: #('simpleText' 'bigFont').
	label := DrsLabel text: aText styleSheet: aStyleSheet. 
	
	labelChunks := label labelChunks.
	
	self assert: label labelChunks size equals: 1.
	self assert: label labelChunks first text equals: 'some text'.
	self assert: label labelChunks first fontSize equals: 16.
	self assert: label labelChunks first fontName equals: 'Source Code Pro'.
]

{ #category : #tests }
DrsLabelTest >> testWithTwoStylesReversed [

	"test order of class definitions"

	| aText label labelChunks aStyleSheet |
	
	aStyleSheet := DrsStyleSheet parse: '
.simpleText { 
	fontName: "Source Code Pro";
	fontSize: 12;
}

.bigFont { 
	fontSize: 16;
}
'.
	
	aText := PdmText string: 'some text' styles: #('bigFont' 'simpleText').
	label := DrsLabel text: aText styleSheet: aStyleSheet. 
	
	labelChunks := label labelChunks.
	
	self assert: label labelChunks size equals: 1.
	self assert: label labelChunks first text equals: 'some text'.
	self assert: label labelChunks first fontSize equals: 12.
	self assert: label labelChunks first fontName equals: 'Source Code Pro'.
]

{ #category : #tests }
DrsLabelTest >> testWithoutStyle [

	| aText label labelChunks aStyleSheet |
	
	aStyleSheet := DrsStyleSheet new.
	
	aText := PdmText string: 'some text'.
	label := DrsLabel text: aText styleSheet: aStyleSheet. 
	
	labelChunks := label sublabels.
	
	self assert: label labelChunks size equals: 1.
	self assert: label labelChunks first text equals: 'some text'.
	self assert: label labelChunks first fontSize equals: 10.
	self assert: label labelChunks first fontName equals: 'Source Sans Pro'.
]

{ #category : #tests }
DrsLabelTest >> testWrapping01 [

	"test wrapping turned off, enough space "

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'one two three four five six seven eight nine ten' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label maxWidth: 250.
	
	label wrappingEnabled: false.

	label bounds innerExtent: 350@100.
	label adaptShapeExtents.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: label visibleLength equals: 48
]

{ #category : #tests }
DrsLabelTest >> testWrapping02 [

	"test wrapping turned off, limit space "

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'one two three four five six seven eight nine ten' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label maxWidth: 250.
	
	label wrappingEnabled: false.

	label bounds innerExtent: 150@100.
	label adaptShapeExtents.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: label visibleLength equals: 21

]

{ #category : #tests }
DrsLabelTest >> testWrapping03 [

	"test wrapping turned off, limit space "

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'one two three four five six seven eight nine ten' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label maxWidth: 250.
	
	label wrappingEnabled: false.

	label bounds innerExtent: 150@100.
	label adaptShapeExtents.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: label visibleLength equals: 21

]

{ #category : #tests }
DrsLabelTest >> testWrapping04 [

	"test wrapping turned on, limit space "

	| aText aStyleSheet label composite c |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Sans Pro";
	fontSize: 12;
} 
'.

	aText := PdmText string: 'one two three four five six seven eight nine ten' style: #normal.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label maxWidth: 250.
	
	label wrappingEnabled: false.

	label bounds innerExtent: 150@100.
	label adaptShapeExtents.

	composite := label labelShape.
	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: label visibleLength equals: 21

]

{ #category : #tests }
DrsLabelTest >> testXPositionOf [ 

	| aText aStyleSheet  label c composite |
	aStyleSheet := DrsStyleSheet parse: '
.normal { 
	fontName: "Source Code Pro";
	fontSize: 16;
} 
.small { 
	fontName: "Source Code Pro";
	fontSize: 10;
} 
'.

	aText := PdmText string: 'abcdef ghijkl mnopqrs tuvwxyz' style: #normal.
	aText addString: 'abcdef ghijkl mnopqrs tuvwxyz abcdef ghijkl mnopqrs tuvwxyz' style: #small.

	label := DrsLabel text: aText styleSheet: aStyleSheet.
	label wrappingEnabled: true. 
	label prepare.
	
	composite := label labelShape.	
	c := RSCanvas new.
	c addShape: composite.
	c addShape: (RSBox new extent: 1 @ 100).
	c addShape: (RSBox new extent: 100 @ 1).
	self inspect: c.
	
	self assert: (label xPositionOf: 1) equals: 0.
	self assert: (label xPositionOf: 2) asInteger equals: 12.
	self assert: (label xPositionOf: 23) asInteger equals: 0.
	self assert: (label xPositionOf: 52) asInteger equals: 0.
	self assert: (label xPositionOf: 53) asInteger equals: 8.
		
	

]
