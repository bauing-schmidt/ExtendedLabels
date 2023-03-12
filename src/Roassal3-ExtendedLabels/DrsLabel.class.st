"
A simple label with only the text.
- configurable via styles
- shortening to given extent / multi-line label
- highlights

## instance variables

- fullText					- 
- fullTextWidth 
- editable 
- compositeShape 
- labelChunks 
- usedLabelChunks 
- sublabels 
- highlightShape 
- characterPositions 
- shortenedWidths 
- highlightRanges 
- highlightColor 
- emphasizedHighlightColor 
- ellipsisSize 
- styleSheet 
- visibleLength 
- naturalHeight 
- wrappingEnabled 
- linesCount 
- extentForAlignment 
- lastAssignedExtent 
- maxBaseline widths 
- labelExtent 
- maxLabelHeight 
- expandable 
- expanded 
- maxLineWidth 
- linesScaling 
- needsExpandIcon 
- appItem
	

"
Class {
	#name : #DrsLabel,
	#superclass : #DrsShape,
	#instVars : [
		'text',
		'fullTextWidth',
		'editable',
		'compositeShape',
		'labelChunks',
		'usedLabelChunks',
		'sublabels',
		'highlightShape',
		'characterPositions',
		'shortenedWidths',
		'highlightRanges',
		'highlightColor',
		'emphasizedHighlightColor',
		'ellipsisSize',
		'styleSheet',
		'visibleLength',
		'naturalHeight',
		'wrappingEnabled',
		'linesCount',
		'extentForAlignment',
		'lastAssignedExtent',
		'maxBaseline',
		'widths',
		'labelExtent',
		'maxLabelHeight',
		'expandable',
		'expanded',
		'maxLineWidth',
		'linesScaling',
		'needsExpandIcon',
		'appItem',
		'cursorInfo',
		'storedTopLeftPosition',
		'horizontalAlignment'
	],
	#classVars : [
		'MetricsProvider'
	],
	#category : #'Roassal3-ExtendedLabels-Labels'
}

{ #category : #'as yet unclassified' }
DrsLabel class >> maximalDimension [

	^ SmallInteger maxVal
]

{ #category : #initialization }
DrsLabel class >> metricsProvider [ 

	^ MetricsProvider ifNil: [ MetricsProvider := DrsFontMetricsProvider new ]
]

{ #category : #initialization }
DrsLabel class >> text: aText [

	^ self new initializeWithText: aText styleSheet: DrsStyleSheet new item: nil maxLineWidth: nil.
]

{ #category : #initialization }
DrsLabel class >> text: aText styleSheet: aStyleSheet [

	^ self new initializeWithText: aText styleSheet: aStyleSheet item: nil maxLineWidth: nil.

]

{ #category : #initialization }
DrsLabel class >> text: aText styleSheet: aStyleSheet item: appItem [

	"the appItem may be needed to access the icons subsystem and determine the shape state 
	like the expand status"

	^ self new initializeWithText: aText styleSheet: aStyleSheet item: appItem  maxLineWidth: nil


]

{ #category : #initialization }
DrsLabel class >> text: aText styleSheet: aStyleSheet item: appItem maxLineWidth: aMaxLineWidth [

	"the appItem may be needed to access the icons subsystem and determine the shape state 
	like the expand status"

	^ self new initializeWithText: aText styleSheet: aStyleSheet item: appItem  maxLineWidth: aMaxLineWidth


]

{ #category : #initialization }
DrsLabel class >> text: aText styleSheet: aStyleSheet maxLineWidth: aWidth [

	^ self new initializeWithText: aText styleSheet: aStyleSheet item: nil maxLineWidth: aWidth.

]

{ #category : #'as yet unclassified' }
DrsLabel >> adaptAdditionalShapesExtents [

	compositeShape adjustToChildren

]

{ #category : #'as yet unclassified' }
DrsLabel >> adaptShapeExtents [

	| assigExt aTextSize | 
		
	self wrappingEnabled ifTrue: [ 
		self adaptSublables.
		^ self ].
	
	assigExt := self assignedExtent.
	
	"round to avoid very small differences causing shrinking of labels"		
	assigExt x rounded >= self fullTextWidth rounded 
		ifTrue: [ 
			self displayedLength: text fullLength.
			self adaptSublables.
			self updateHighlightShapePositions.
			^ self ].	
		
	aTextSize := text fullLength.
	
	[ aTextSize > 0 and: [((self ensureCharacterPositions at: aTextSize) + (self ellipsisWidthAt: aTextSize) > assigExt x)]]
		whileTrue: [ aTextSize := aTextSize - 1 ].

	self displayedLength: aTextSize.
	
	self applicationItem ifNotNil: [:anAppItem | anAppItem activeEditor 
		ifNotNil: [:ipe | ipe useExtent: assigExt ]].
	
	self adaptSublables.
"	self labelShape parent ifNotNil: [ :aParent | aParent extent: assigExt ].			
"

	self adaptAdditionalShapesExtents
]

{ #category : #'as yet unclassified' }
DrsLabel >> adaptSublables [

	| anExtent |
	
	anExtent := self assignedExtent.

	lastAssignedExtent = anExtent ifTrue: [ ^ self ].
	
	self privAdaptSublables.
	
	 lastAssignedExtent := anExtent.
]

{ #category : #adding }
DrsLabel >> addAdditionalShapesTo: aComposite [.

]

{ #category : #private }
DrsLabel >> addHighlightShape: aShape [

	highlightShape ifNil: [ highlightShape := aShape ].
	
	highlightShape lastShape next: aShape.
	aShape next: nil.
	

]

{ #category : #'selection highlights' }
DrsLabel >> addHighlightShapesOf: ranges color: aColor [
		self horizontalAlignment = #right ifTrue: [ self halt ].
	ranges do: [ :aRange |
		| newShape | 
		(self rectanglesForSubstringFrom: aRange) do: [ :rect |
			newShape := DrsTextHighlightBox new
				extent: rect extent;
				cornerRadius: 0;
				color: aColor;
				range: aRange;	
				highlightExtent: rect extent;
				highlightPosition: rect topLeft.
			
			self addHighlightShape: newShape	
	] ].

]

{ #category : #actions }
DrsLabel >> addLabelShapesAt: aPoint [
	
	"aPoint defines top left position relative to the composite shape center"

	sublabels ifEmpty: [ ^ self ].
	sublabels do: [ :each | compositeShape addBasicShape: each ].
	
	self wrappingEnabled 
		ifTrue: [ self setupSubLabelsMultilineAt: aPoint ]
		ifFalse: [  self setupSubLabelsAt: aPoint ]
]

{ #category : #'selection highlights' }
DrsLabel >> addRoassalShapeFor: aHighlightShape [ 
	
	"returns false if no other shape should be added because we already reached the last visible character"

	| limit aPosition anExtent result invisible |
		
	result := true.
	
	invisible := aHighlightShape range first > self visibleLength.
	
	limit := self isShrinked  
		ifTrue: [ 
			invisible
				ifFalse: [  self visibleLength  ]
				ifTrue: [ 
					"we start behind last visible characters at the ellisis beginning"
					self visibleLength + 1 ] ]
		ifFalse: [ self text fullLength + 1 ].		
					
	aPosition := aHighlightShape range first <= limit
		ifTrue: [ aHighlightShape highlightPosition ]
		ifFalse: [ 
			| x |
			result := false.
			x := self ensureCharacterPositions at: (limit max: 1).
			x @ aHighlightShape highlightPosition y ].

	anExtent := aHighlightShape range last <= limit 
		ifTrue: [ aHighlightShape highlightExtent ]
		ifFalse: [ 
			| x offset |
			result := false.
			"start begind the last character (before elllispis) in case the invisible range"
			offset := invisible ifTrue: [ 0 ] ifFalse: [ 1 ].
			x := (self characterPositionAt: limit + offset) + (self ellipsisWidthAt: limit) - aPosition x.
			x @ aHighlightShape highlightExtent y  ].
		
	aHighlightShape isCursor ifTrue: [ 
		| cursorPosition line lineBeginning  |
		cursorPosition := aHighlightShape range first.
		line := self lineIndexOfCharacterAt: cursorPosition.
		lineBeginning := self ensureCharacterPositions at: (self firstChunkOfLine: line) startingIndex.
		anExtent := cursorInfo width @anExtent y.
		aPosition := ((self ensureCharacterPositions at: aHighlightShape range first) - lineBeginning) @ aPosition y ].

	aHighlightShape visible: true.
	self ensureCompositeShape.
	self labelShape shapes
		ifEmpty: [ 
			"cursor can be the only one"
			self labelShape addShape: aHighlightShape ]
		ifNotEmpty: [ 
			self labelShape addShape: aHighlightShape before: self highlightTargetShape. ].
			
	aHighlightShape visibleExtent: anExtent.
	aHighlightShape visiblePosition: aPosition.	
		
	^ result
]

{ #category : #accessing }
DrsLabel >> appItem [ 

	^ self shapeGroup 
		ifNil: [ ^ nil ]
		ifNotNil: [ :aGroup | aGroup applicationItem ]
]

{ #category : #accessing }
DrsLabel >> baseline [
	^ maxBaseline
]

{ #category : #accessing }
DrsLabel >> baseline: anObject [
	bounds baseline: anObject
]

{ #category : #accessing }
DrsLabel >> characterPositionAt: index [ 

	| positions |
	
	positions := self ensureCharacterPositions.

	^ positions at: (index min: positions size max: 1)
]

{ #category : #accessing }
DrsLabel >> characterPositionOf: xPos atLine: lineIndex [ 

	"used for moving cursor up or down between lines"

	| lineChunks result left |
	
	result := 1.	
	left := 0.
	lineChunks := labelChunks select: [ :each | each lineIndex = lineIndex ].
	lineChunks ifNotEmpty: [ 
		result := lineChunks first startingIndex ].
	lineChunks do: [ :aChunk |
		aChunk characterPositions allButFirst do: [ :pos |
			(left + pos) rounded > xPos rounded ifTrue: [ ^ result max: 1 ].
			result := result + 1.
		].
		left := left + aChunk width.
	 ].
	^ result max: 1
]

{ #category : #actions }
DrsLabel >> composeShapes [
	
	compositeShape := self ensureCompositeShape.
	
	self resetShapes.
	self computeLabelExtents.
	self addAdditionalShapesTo: compositeShape.
	self addLabelShapesAt: "self overallExtent half negated + "self labelOffset.
	self placeAdditionalShapes.
		
	compositeShape adjustToChildrenRelatively.

	^ compositeShape 
]

{ #category : #actions }
DrsLabel >> computeAssignedExtent [

	self bounds innerExtent: self naturalExtent.
]

{ #category : #actions }
DrsLabel >> computeLabelExtents [

	| sublabelsPerLine reduction overallWidth overallHeight |

	sublabels ifEmpty: [ ^ self ].
	
	maxBaseline := sublabels max: [ :each | each baseline ]. 
	wrappingEnabled ifTrue: [ 
		maxBaseline := maxBaseline max: self expandIconsBaseline ].
	maxLabelHeight := sublabels max: [ :each | each height ].
	widths := sublabels collect: [ :each | each width ].

	self wrappingEnabled ifFalse: [ 
		labelExtent := widths sum @ maxLabelHeight.
		^ self ].	
		
	needsExpandIcon ifTrue: [ 
		labelExtent := maxLineWidth@maxLabelHeight.
		^ self ].

	sublabelsPerLine := OrderedDictionary new.
	sublabels do: [ :aLabel | (sublabelsPerLine at: (aLabel propertyAt: #lineIndex) ifAbsentPut: [ OrderedCollection new ]) add: aLabel ].

	reduction := self linesReduction.
	overallHeight := maxLabelHeight * linesCount + reduction.
	overallWidth := 0.
	sublabelsPerLine associations do: [ :assoc | 
		overallWidth := overallWidth max: (assoc value collect: [ :each | each width ]) sum  ].

	labelExtent := overallWidth @ overallHeight

]

{ #category : #private }
DrsLabel >> computeTextExtentOfLabel: aLabelShape [
	
	^ (self metricsProvider extentsOf: aLabelShape text font: aLabelShape font) in: [ :te | te width @ te height ]
]

{ #category : #private }
DrsLabel >> createLabelChunksFrom: aText styleSheet: aStyleSheet [

	^ self createLabelChunksFrom: aText styleSheet: aStyleSheet maxWidth: maxLineWidth
]

{ #category : #private }
DrsLabel >> createLabelChunksFrom: aText styleSheet: aStyleSheet maxLineWidth: aMaxLineWidth [

	maxLineWidth := aMaxLineWidth.
	^ self createLabelChunksFrom: aText styleSheet: aStyleSheet maxWidth: maxLineWidth
]

{ #category : #private }
DrsLabel >> createLabelChunksFrom: aText styleSheet: aStyleSheet maxWidth: aWidth [

	"creates label chunks to later use them for creation of real labels"
	
	styleSheet := aStyleSheet.
	visibleLength := aText fullLength.
	
	labelChunks := self wrappingEnabled 
		ifTrue: [ 
			self labelChunksWrappedFrom: aText with: aStyleSheet maxWidth: aWidth ] 
		ifFalse: [ self 
		 	labelChunksFrom: aText with: aStyleSheet
		   length: visibleLength ]
]

{ #category : #accessing }
DrsLabel >> cursorInfo [ 

	^ cursorInfo
]

{ #category : #accessing }
DrsLabel >> cursorPositionAt: aPoint [ 

	| lineIndex | 
	lineIndex := self lineIndexAt: aPoint. 
	^ self characterPositionOf: aPoint x atLine: lineIndex.
]

{ #category : #accessing }
DrsLabel >> displayedLength: aLength [


	self wrappingEnabled ifTrue: [ 
		"ignore"
		^ self ].

	self visibleLength: aLength 

]

{ #category : #accessing }
DrsLabel >> displayedText [

	self wrappingEnabled ifTrue: [ ^ text fullLength ].

	^ self text asString first: self visibleLength
]

{ #category : #accessing }
DrsLabel >> editable [
	^ editable
]

{ #category : #accessing }
DrsLabel >> editable: anObject [
	editable := anObject
]

{ #category : #'as yet unclassified' }
DrsLabel >> ellipsis [

	^ '…'
]

{ #category : #accessing }
DrsLabel >> ellipsisWidthAt: aPosition [ 

	| chunk font |
	
	chunk := self labelChunkAt: aPosition.
	chunk ifNil: [ ^ 0 ].
	font := chunk font.
	^ (self metricsProvider extentsOf: self ellipsis font: font) width
	
	
]

{ #category : #'text extents' }
DrsLabel >> ensureCharacterPositions [

	^ characterPositions ifNil: [ 
		  | currentPosition |
			naturalHeight := 0.

		  characterPositions := OrderedCollection new.
		  shortenedWidths := OrderedCollection new.

		  currentPosition := 0.
		  labelChunks withIndexDo: [ :labelChunk :index | 
			  | positions |
			  naturalHeight := naturalHeight max: labelChunk height.
			  index > 1 ifTrue: [ 
				  characterPositions removeLast.
				  shortenedWidths removeLast ].
			  positions := labelChunk characterPositions.
			  positions do: [ :aPosition | 
				  | positionFromTheBeginning |
				  positionFromTheBeginning := currentPosition + aPosition.
				  characterPositions add: positionFromTheBeginning.
				  shortenedWidths add:
					  positionFromTheBeginning + labelChunk ellipsisWidth ].
			  currentPosition := currentPosition + positions last ].

	  characterPositions. ]
]

{ #category : #actions }
DrsLabel >> ensureCompositeShape [
	
	^ compositeShape ifNil: [
		compositeShape := DrsComposite new model: self ].
	

]

{ #category : #actions }
DrsLabel >> ensureNaturalExtent [ 

	^ self naturalExtent
]

{ #category : #accessing }
DrsLabel >> expandIconAlignment [
 
	"#left or #right"
	
	^ #left
]

{ #category : #initialization }
DrsLabel >> expandIconWidth [ 

	^ 16
]

{ #category : #private }
DrsLabel >> expandIconsBaseline [

	^ 9
]

{ #category : #private }
DrsLabel >> expandIconsHeight [

	^ (self expandIconsBaseline * 1.3) asInteger
]

{ #category : #initialization }
DrsLabel >> expandable [ 

	"to set, use stylesheet"
	
	^ expandable
]

{ #category : #accessing }
DrsLabel >> expanded [

	^ expanded

]

{ #category : #accessing }
DrsLabel >> extentAdditionForIcon [ 

	^ 0
]

{ #category : #accessing }
DrsLabel >> extentForAlignment [

	^ extentForAlignment ifNil: [ extentForAlignment := self visibleExtent ].
]

{ #category : #accessing }
DrsLabel >> extentForBounds [ 

	^ 800@50 
]

{ #category : #accessing }
DrsLabel >> firstCharacterOfLine: aLineIndex [ 

	"returns a character position of the first character of line with the given index"
	
	self labelChunks do: [ :each | 
		each lineIndex = aLineIndex ifTrue: [ 
			^ each startingIndex ] ].
	
	self pdmError: #lineIndexIsBiggerThanNumberOfLines
]

{ #category : #accessing }
DrsLabel >> firstChunkOfLine: lineIndex [ 

	^ labelChunks detect: [ :each | each lineIndex = lineIndex ]
]

{ #category : #private }
DrsLabel >> firstStyleOrNil [

	| firstChunk | 
	
	firstChunk := self text firstChunkOrNil.
	firstChunk ifNil: [ ^ firstChunk ].
	
	^ styleSheet
			stylesFrom: firstChunk styleClassNames
			key: firstChunk lookUpKey 

]

{ #category : #initialization }
DrsLabel >> fontAt: index [ 

	"it expects some font attributes are always set, at least for the first text character"

	| attributes ref| 
	
	attributes := self text attributesAt: index.
	ref := attributes detect: [ :each | each isKindOf: TextFontReference ].
	^ ref font 
]

{ #category : #'text extents' }
DrsLabel >> fullTextExtents [
	^ self ensureCharacterPositions last @ naturalHeight
]

{ #category : #'text extents' }
DrsLabel >> fullTextWidth [
	"without any transformation"
	
	^ fullTextWidth ifNil: [ fullTextWidth := self fullTextExtents x ]
]

{ #category : #private }
DrsLabel >> getIconForm: iconName [ 

	^ self iconNamed: iconName

]

{ #category : #accessing }
DrsLabel >> hasCursor [ 

	cursorInfo ifNil: [ ^ false ].
	^ cursorInfo enabled
]

{ #category : #'text extents' }
DrsLabel >> hasHighlights [

	^ highlightShape notNil
]

{ #category : #private }
DrsLabel >> heightOfLine: lineIndex [ 

	lineIndex = 1 ifTrue: [ ^ naturalHeight ].
	^ naturalHeight * linesScaling.
]

{ #category : #'selection highlights' }
DrsLabel >> highlightRanges: ranges color: aColor [
		
	self addHighlightShapesOf: ranges color: aColor.

	self updateHighlightShapePositions.
	
]

{ #category : #private }
DrsLabel >> highlightShapes [

	"try to avoid of using this method. Tests support"

	| result | 
	
	result := OrderedCollection new.
	self highlightShapesDo: [ :aShape | result add: aShape ].
	^ result
]

{ #category : #private }
DrsLabel >> highlightShapesDo: aBlock [ 

	| aShape |
	
	highlightShape ifNil: [ ^ self ].
	
	aShape := highlightShape.
	[ aShape isNil ] whileFalse: [ 
		aBlock value: aShape.
		aShape := aShape next ]
]

{ #category : #'selection highlights' }
DrsLabel >> highlightTargetShape [ 

	^ self labelShape shapes last
]

{ #category : #'selection highlights' }
DrsLabel >> highlightText: aString emphasized: aBoolean [

	| fullTextLowercase stringLowercase aColor |
	
	fullTextLowercase := self text asString asLowercase.
	stringLowercase := aString asLowercase.

	(fullTextLowercase includesSubstring: stringLowercase)
		ifFalse: [ ^ Array new ].
		
	highlightRanges := fullTextLowercase allRangesOfSubstring: stringLowercase.

	aColor := aBoolean 
		ifTrue: [ emphasizedHighlightColor ]
		ifFalse: [ highlightColor ].

	self highlightRanges: highlightRanges color: aColor
]

{ #category : #accessing }
DrsLabel >> horizontalAlignment [

	^ horizontalAlignment
]

{ #category : #accessing }
DrsLabel >> horizontalAlignment: anObject [

	horizontalAlignment := anObject
]

{ #category : #'selection highlights' }
DrsLabel >> iconOffset [

	^ 0
]

{ #category : #'text extents' }
DrsLabel >> initialize [

	super initialize.
	editable := false.
	highlightColor := Color red alpha: 0.33.
	emphasizedHighlightColor := Color red darker alpha: 0.6.
	sublabels := OrderedCollection new.
	labelChunks := OrderedCollection new.
	wrappingEnabled := false.
	labelExtent := 0@0.
	visibleLength := 0.
	linesScaling := 1.
	expandable := false.
	expanded := { true. false } atRandom.
	needsExpandIcon := false.
	cursorInfo := nil. "do not allocate the cursor info if not needed"
	horizontalAlignment := #left
]

{ #category : #initialization }
DrsLabel >> initializeWithText: aText styleSheet: aStyleSheet item: anApplicationItem maxLineWidth: aMaxLineWidth [

	text := aText.

	wrappingEnabled := ((text firstStyle: 'wrapping' from: aStyleSheet default: 0) = 1).
	expandable := ((text firstStyle: 'expandable' from: aStyleSheet default: 0) = 1).
	expanded := ((text firstStyle: 'expanded' from: aStyleSheet default: 0) = 1).
	
	appItem := anApplicationItem.
	appItem ifNotNil: [ 
		appItem labelExpanded ifNotNil: [ :val |
		expanded := val  ] ].

	self createLabelChunksFrom: text styleSheet: aStyleSheet maxLineWidth: aMaxLineWidth.
	
	wrappingEnabled ifTrue: [ self prepareAsMultiLine ].
	

]

{ #category : #accessing }
DrsLabel >> isShrinked [

	self wrappingEnabled ifTrue: [ ^ false ].

	^ self text fullLength ~= self displayedText size
]

{ #category : #accessing }
DrsLabel >> labelChunkAt: aPosition [ 

	| length |
	length := 0.

	labelChunks do: [ :each | 
		length := length + each fullLength.
		aPosition <= length ifTrue: [ ^ each ]  ].
	
	aPosition = (length + 1) ifTrue: [ ^ labelChunks last ].
	
	^ nil
]

{ #category : #accessing }
DrsLabel >> labelChunkAtIndex: anIndex [ 

	| length |
	
	length := 0.
	labelChunks do: [ :each | 
		length := length + each fullSize.
		anIndex <= length ifTrue: [ ^ each ] ].
	
	^ labelChunks last
]

{ #category : #accessing }
DrsLabel >> labelChunks [ 

	^ labelChunks
]

{ #category : #accessing }
DrsLabel >> labelChunksFrom: aText with: aStyleSheet length: aLength [

	"creates label chunks to later use them for creation of real labels"

	| aFontName aFontSize aColor currentColor freeLength nextChunksAreHidden |
	aFontName := aStyleSheet defaultFontName.
	aFontSize := aStyleSheet defaultFontSize.
	aColor := aStyleSheet defaultColor.

	freeLength := aLength.
	nextChunksAreHidden := false.

	labelChunks := OrderedCollection new.

	aText chunks do: [ :aPdmChunk | 
		| labelChunk styles |
		labelChunk := aPdmChunk asLabelChunk.
		labelChunk startingIndex: (aLength - freeLength + 1).

		nextChunksAreHidden
			ifTrue: [ labelChunk length: -1 ]
			ifFalse: [ 
				freeLength < aPdmChunk string size ifTrue: [ 
					labelChunk length: freeLength ].
				freeLength := freeLength - labelChunk length ].

		((nextChunksAreHidden not and: [ freeLength = 0 ]) and: [ labelChunk isShrinked ]) ifTrue: [ 
			nextChunksAreHidden := true ].

		styles := aStyleSheet
			          stylesFrom: aPdmChunk styleClassNames
						 variants: aText styleVariants 
			          key: aPdmChunk lookUpKey.

		"running values"
		aFontName := styles get: 'fontName' defaultValue: aFontName.
		aFontSize := styles get: 'fontSize' defaultValue: aFontSize.
		currentColor := styles get: 'textColor' defaultValue: nil.
		aColor := currentColor
			          ifNil: [ aColor ]
			          ifNotNil: [ currentColor ].

		labelChunk fontName: aFontName size: aFontSize color: aColor.

	labelChunk isVisible ifTrue: [ 
		labelChunks add: labelChunk ] ].

	^ labelChunks
]

{ #category : #accessing }
DrsLabel >> labelChunksWrappedFrom: aText with: aStyleSheet maxWidth: aMaxWidth [

	"creates label chunks to later use them for creation of real labels"

	| aFontName aFontSize aColor currentColor currentLineWidth currentLineIndex chunksLeft eatenChunkLenght remLineLength processedLength expandIconOrNil ignoreRestOfLines currentMaxLineWidth |
	
	aFontName := aStyleSheet defaultFontName.
	aFontSize := aStyleSheet defaultFontSize.
	aColor := aStyleSheet defaultColor.
   maxLineWidth := aMaxWidth ifNil: [ aStyleSheet defaultMaxLabelWidth ].

	"get max label width and lines scaling from the first style"
	maxLineWidth := aText firstStyle: 'maxLineWidth' from: aStyleSheet default: maxLineWidth. 
	linesScaling := aText firstStyle: 'linesScaling' from: aStyleSheet default: 1. 

	aMaxWidth ifNotNil: [ 
		maxLineWidth := maxLineWidth min: aMaxWidth ].
	
	currentMaxLineWidth := maxLineWidth.

	currentLineIndex := 1.
	currentLineWidth := 0.
	eatenChunkLenght := 0.

	labelChunks := OrderedCollection new.
	processedLength := 0.
	
	chunksLeft := aText chunks copy.

	expandIconOrNil := (self expandable and: [ self expanded not ])
		ifTrue: [ 
			currentMaxLineWidth := currentMaxLineWidth - self expandIconWidth.
			RSBitmap new form: (self getIconForm: 'text_less_9.png')
	 ].

	ignoreRestOfLines := false.
	
	(self expandable and: self expanded) ifTrue: [ 
		| iconsChunk | 
		iconsChunk := PdmTextCollapseIconChunk new icon: (RSBitmap new 
			form: (self getIconForm: 'text_less_9.png');
			when: RSMouseClick do: (MessageSend receiver: self selector: #toggleExpanded)
			).
		chunksLeft add: iconsChunk.

		iconsChunk := PdmTextCollapseIconChunk new icon: (RSBitmap new form: (self getIconForm: #arrowDown)).
		chunksLeft add: iconsChunk.
	 ].	
	
	remLineLength := currentMaxLineWidth.

	[ chunksLeft notEmpty and: [ ignoreRestOfLines not] ] whileTrue: [ 
		| aTextChunk styles labelChunk firstChunk  reminder| 
		aTextChunk := chunksLeft first.
		chunksLeft removeFirst.

		styles := aStyleSheet
			          stylesFrom: aTextChunk styleClassNames
						variants: aText styleVariants 
			          key: aTextChunk lookUpKey.
		"running values"
		aFontName := styles get: 'fontName' defaultValue: aFontName.
		aFontSize := styles get: 'fontSize' defaultValue: aFontSize.
		currentColor := styles get: 'textColor' defaultValue: nil.
		aColor := currentColor
			          ifNil: [ aColor ]
			          ifNotNil: [ currentColor ].

		reminder := aTextChunk string .
		
		[ 
			| newReminder currentFontSize |
			labelChunk := aTextChunk asLabelChunk: reminder.
			labelChunk lineIndex: currentLineIndex.
			currentFontSize := currentLineIndex = 1 
				ifTrue: [ aFontSize ]
				ifFalse: [ aFontSize * linesScaling ].
			labelChunk fontName: aFontName size: currentFontSize color: aColor.
			firstChunk := labelChunk subChunkOfMaxLength: remLineLength for: self.
			remLineLength := remLineLength - firstChunk width.
			firstChunk startingIndex: processedLength + 1.
			processedLength := processedLength + firstChunk fullSize.
			labelChunks add: firstChunk.
			newReminder := (reminder allButFirst: firstChunk fullSize).

			(newReminder isEmpty not and: [ newReminder ~= reminder ]) ifTrue: [
				currentLineIndex := currentLineIndex + 1.
				ignoreRestOfLines := expandIconOrNil notNil.
				ignoreRestOfLines ifFalse: [ 
					"set only when needed to keep the right value for determining 
					of the offset of the expand icon"
					remLineLength := currentMaxLineWidth ]

	      ].
			reminder := newReminder.
			reminder isEmpty or: [ ignoreRestOfLines and: [currentLineIndex > 1] ].
		] whileFalse.
	
	 ].

	((self expandable and: self expanded not) and: [ currentLineIndex > 1 ]) ifTrue: [
		| iconsChunk labelChunk |
		iconsChunk := PdmTextIconChunk new icon: (RSBitmap new form: (self getIconForm: 'text_more_9.png');
	when: RSMouseClick do: (MessageSend receiver: self selector: #toggleExpanded)).
			labelChunk := iconsChunk asLabelChunk: nil.
			labelChunk paddingLeft: 4"remLineLength".
			labelChunk lineIndex: 1.
			labelChunk fontName: aFontName size: aFontSize color: aColor.
			labelChunks add: labelChunk.	
	].
	
	^ labelChunks
]

{ #category : #accessing }
DrsLabel >> labelOffset [

	"for simple labels, the label is always zero. The composite shape needs to have at least some shape touching minimal top left borders."

	^ 0@0
]

{ #category : #accessing }
DrsLabel >> labelShape [ 

	^ compositeShape 
]

{ #category : #accessing }
DrsLabel >> lineIndexAt: aPoint [

	| sum |
	sum := 0.
	1 to: self linesCount do: [ :anIndex |
		sum := sum + (self heightOfLine: anIndex).
		aPoint y <= sum ifTrue: [ ^ anIndex ] ].
	
	^ self linesCount

	
]

{ #category : #'selection highlights' }
DrsLabel >> lineIndexForCharacter: characterPosition [ 

	^ (self labelChunkAt: characterPosition)
		ifNil: [ 1 ]
		ifNotNil: [ :chunk | chunk lineIndex ]
]

{ #category : #accessing }
DrsLabel >> lineIndexOfCharacterAt: anIndex [ 

	^ (self labelChunkAtIndex: anIndex) lineIndex
]

{ #category : #accessing }
DrsLabel >> linesCount [ 

	^ linesCount ifNil: [ 1 ]
]

{ #category : #accessing }
DrsLabel >> linesReduction [

	| lc |
	
	lc := self linesCount.
	lc = 1 ifTrue: [ ^ 0 ].
	linesScaling = 1 ifTrue: [ ^ 0 ].
	
	^ ((linesScaling - 1) * naturalHeight * (lc - 1))
	
 
]

{ #category : #accessing }
DrsLabel >> linesScaling [ 

	^ linesScaling 
]

{ #category : #accessing }
DrsLabel >> maxLine [ 

	^ (labelChunks detectMax: [ :each | each lineIndex ]) lineIndex
]

{ #category : #accessing }
DrsLabel >> maxLineWidth [ 

 	^ maxLineWidth ifNil: [ ^ self class maximalDimension ]
]

{ #category : #accessing }
DrsLabel >> maxLineWidth: aNumber [ 

	"try to do not use it directly"
	maxLineWidth := aNumber.
]

{ #category : #accessing }
DrsLabel >> maxLineWidthTreated [ 

	wrappingEnabled ifFalse: [ ^ self class maximalDimension ].

	(wrappingEnabled and: [ self linesCount = 1 ]) ifTrue: [ 
		^ self class maximalDimension  ].

 	^ self maxLineWidth
]

{ #category : #metrics }
DrsLabel >> metricsProvider [ 

	^ self class metricsProvider
]

{ #category : #'as yet unclassified' }
DrsLabel >> minWidth [

	(self wrappingEnabled and: [ self linesCount > 1]) ifTrue: [ 
		maxLineWidth ifNil: [ ^ super minWidth  ].
		^ minWidth := maxLineWidth ].
	
	(self wrappingEnabled) ifTrue: [ 
		^  self minimalLabelWidth max: labelExtent x ].
		
	^ self minimalLabelWidth min: labelExtent x
]

{ #category : #'selection highlights' }
DrsLabel >> minimalHighlightWidth [

	"when we need to select characters like line end, the selection would be invisible without this miniaml value"
	^ 2
]

{ #category : #'as yet unclassified' }
DrsLabel >> minimalLabelWidth [

	^ naturalHeight * 3
]

{ #category : #'selection highlights' }
DrsLabel >> moveCursorAt: position [

	((position < 1) or: (position > characterPositions size)) ifTrue: [ 
		self removeCursor.
		^ self ].

	self moveCursorAt: position canvas: nil
]

{ #category : #'selection highlights' }
DrsLabel >> moveCursorAt: position canvas: aCanvas [

	| newShape aRange |
		
	cursorInfo := DrsCursorInfo new.
		
	aRange := position to: position.
		
	(self rectanglesForSubstringFrom: aRange) do: [ :rect |
		newShape := DrsTextHighlightBox new
			extent: cursorInfo width@rect height;
			isCursor: true;
			cornerRadius: 0;
			color: cursorInfo color;
			range: aRange copy;	
			highlightExtent: cursorInfo width@rect height;
			highlightPosition: rect topLeft - (cursorInfo width half@0).
		cursorInfo cursorShape: newShape.				
		
		self addHighlightShape: newShape.
	].

	self updateHighlightShapePositions.

]

{ #category : #actions }
DrsLabel >> msg [

	|  origin |

	origin := 1.
	
	sublabels withIndexDo: [ :aLabel :index | 
		false ifFalse: [ origin := origin negated ].
	].

]

{ #category : #accessing }
DrsLabel >> naturalExtent [

	^ self naturalLabelExtent
]

{ #category : #accessing }
DrsLabel >> naturalInnerExtent [ 

	^ self naturalLabelExtent
]

{ #category : #accessing }
DrsLabel >> naturalLabelExtent [

	self ensureCharacterPositions.
	
	self wrappingEnabled ifTrue: [ 
		^ labelExtent x @ (naturalHeight * self linesCount + self linesReduction ) ].
	
	^ (characterPositions ifEmpty: [ 0 ] ifNotEmpty: [ :anArray | anArray last]) @ naturalHeight
]

{ #category : #'selection highlights' }
DrsLabel >> originCorrection [

	^ 0@0
]

{ #category : #accessing }
DrsLabel >> overallExtent [ 

	^ labelExtent + self extentAdditionForIcon
]

{ #category : #actions }
DrsLabel >> placeAdditionalShapes [ 
]

{ #category : #'selection highlights' }
DrsLabel >> placeHighlightShapesWith: parentLabelExtent [

	self highlightShapesDo: [ :aShape |
		"the composite position is the center of it."
		aShape visible ifTrue: [ 
			aShape extent: aShape visibleExtent.
			aShape topLeftPosition: parentLabelExtent half negated + (aShape visiblePosition) + self topLeftPadding  + self originCorrection negated ]].		
]

{ #category : #private }
DrsLabel >> position [ 

	 ^ roassalShape position
]

{ #category : #accessing }
DrsLabel >> prepare [ 

	self readPropertiesFromStyleSheet.
	self computeAssignedExtent.
	self privAdaptSublables.
]

{ #category : #accessing }
DrsLabel >> prepareAsMultiLine [

	self labelChunksWrappedFrom: self text with: styleSheet maxWidth: maxLineWidth.
	linesCount := 1.
	labelChunks do: [ :each | linesCount := linesCount max: each lineIndex ].
	
	self minWidth: self maxLineWidthTreated.

]

{ #category : #accessing }
DrsLabel >> printOn: aStream [ 

	super printOn: aStream.
	aStream 
		nextPutAll: '(';
		nextPutAll: self text asString;
		nextPutAll: ')'
		
]

{ #category : #'as yet unclassified' }
DrsLabel >> privAdaptSublables [

	| maxLineIndex |
	
	self resetExtentForAlignment.
		
	maxLineIndex := 1.

	sublabels := OrderedCollection new.
	labelChunks do: [ :aChunk | 
		| aLabel labelBaseline |
		aLabel := aChunk createShape.
		sublabels add: aLabel.
		maxLineIndex := aChunk lineIndex max: maxLineIndex.
		labelBaseline := aChunk baseline.
		aLabel baseline: labelBaseline ].

	linesCount := maxLineIndex.

	self composeShapes.

]

{ #category : #accessing }
DrsLabel >> readPropertiesFromStyleSheet [
]

{ #category : #'selection highlights' }
DrsLabel >> rectanglesForSubstringFrom: aRange [

	| positions topLeft corner aLineIndex y lineStart subrangeStart subrangeEnd currentLineIndex resultRects |
	positions := self ensureCharacterPositions.
	
	subrangeStart := aRange first.
	subrangeEnd := subrangeStart.
	currentLineIndex := self lineIndexOfCharacterAt: aRange first.
	resultRects := OrderedCollection new.

	aLineIndex := currentLineIndex.

	aRange first to: aRange last do: [ :charIndex | 
		aLineIndex := self lineIndexOfCharacterAt: charIndex.
		aLineIndex = currentLineIndex 
			ifTrue: [ subrangeEnd := charIndex ]
			ifFalse: [ 
				lineStart := positions at: ((self firstChunkOfLine: currentLineIndex) startingIndex).
				y := self yPosOf: aLineIndex - 1.
				topLeft := ((positions at: subrangeStart) - lineStart)@ y.
				corner := ((positions at: subrangeEnd) - lineStart) @ (y + (self heightOfLine: aLineIndex) ).
				currentLineIndex := aLineIndex.
				subrangeStart := charIndex. 
				subrangeEnd := charIndex.
				resultRects add: (topLeft corner: corner).
			]
	].

	lineStart := positions at: ((self firstChunkOfLine: currentLineIndex) startingIndex).
	y :=  self yPosOf: aLineIndex.
	topLeft := ((positions at: (subrangeStart min: positions size)) - lineStart)@ y.
	corner := (((positions at: ((subrangeEnd + 1) min: positions size)) - lineStart) max: (topLeft x+self minimalHighlightWidth)) @ (y + (self heightOfLine: aLineIndex)).
	resultRects add: (topLeft corner: corner).

	^ resultRects
]

{ #category : #'selection highlights' }
DrsLabel >> removeCursor [ 

	cursorInfo := nil.
]

{ #category : #'selection highlights' }
DrsLabel >> removeHighlightShapesFromComposite [

	self highlightShapesDo: [ :each | 
		each visible ifTrue: [ 
			(compositeShape shapes includes: each) ifTrue: [ compositeShape removeShape: each ] ] ].
	
]

{ #category : #'selection highlights' }
DrsLabel >> removeHighlights [

	self removeHighlightShapesFromComposite.
	highlightShape := nil.
		
]

{ #category : #accessing }
DrsLabel >> resetCaches [ 

	self resetCharacterPositions.
]

{ #category : #accessing }
DrsLabel >> resetCharacterPositions [

	characterPositions := nil.
	self ensureCharacterPositions.
]

{ #category : #'as yet unclassified' }
DrsLabel >> resetExtentForAlignment [

	extentForAlignment := nil
]

{ #category : #actions }
DrsLabel >> resetShapes [ 

	compositeShape resetChildren.
]

{ #category : #accessing }
DrsLabel >> roassalShape [

	^ compositeShape
]

{ #category : #actions }
DrsLabel >> setupSubLabelsAt: topLeftPosition [

	 | origin | 
	
	origin := topLeftPosition.
	sublabels withIndexDo: [ :aLabel :index | 
		| aBaseline y aWidth |
		aBaseline := aLabel baseline.
		y := maxBaseline - aLabel baseline.
		aLabel position: origin + (0 @ y) + aLabel extent half.
		aWidth := widths at: index.
		origin := origin + ((labelChunks at: index) width @ 0) ].
	
]

{ #category : #actions }
DrsLabel >> setupSubLabelsMultilineAt: topLeftPositionn [

	| origin lastLineIndex lineWidths |

	origin := topLeftPositionn.
	
	horizontalAlignment = #left ifFalse: [ 
		lineWidths := (sublabels groupedBy: [ :each | each propertyAt: #lineIndex ]) collect: [ :assoc | | lineLabels |
			lineLabels := assoc value.
			lineLabels sum: [ :each | each extent x ] ifEmpty: [ 0 ].
		 ] ].
	
	lastLineIndex := 1.
	sublabels withIndexDo: [ :aLabel :index | 
		| aBaseline y aWidth lineIndex yOffset paddingOffset lineOffset |
		aBaseline := aLabel propertyAt: #baseline.
		lineIndex := aLabel propertyAt: #lineIndex.
		paddingOffset := aLabel propertyAt: #paddingOffset.
		lineIndex = lastLineIndex ifFalse: [ origin := topLeftPositionn x @ origin y ].
		lastLineIndex := lineIndex.
	
		y := (lineIndex > 1)
			ifFalse: [ maxBaseline - aLabel baseline. ]
			ifTrue: [ maxBaseline * linesScaling - aLabel baseline. ].
	
		yOffset := self yPosOf: lineIndex.
		y := y + yOffset.
		
		lineOffset := 0.
		horizontalAlignment = #right ifTrue: [		
			lineOffset := (maxLineWidth - (lineWidths at: lineIndex)) .
		].
		
		horizontalAlignment = #center ifTrue: [		
			lineOffset := (maxLineWidth - (lineWidths at: lineIndex)) half.
		].

		aLabel position: origin + (lineOffset @ 0) + (0 @ y) + aLabel extent half + paddingOffset.
		aWidth := widths at: index.	
		
		origin := origin + ((labelChunks at: index) width @ 0)].

]

{ #category : #private }
DrsLabel >> shortenedWidthForLength: anInteger [

	self assert: self text fullLength ~= anInteger.

	^ shortenedWidths at: anInteger + 1
]

{ #category : #accessing }
DrsLabel >> shortenedWidths [

	^ shortenedWidths
]

{ #category : #accessing }
DrsLabel >> storedTopLeftPosition [

	^ storedTopLeftPosition
]

{ #category : #accessing }
DrsLabel >> sublabels [ 

	^ sublabels
]

{ #category : #accessing }
DrsLabel >> swapExpanded [ 

	expanded := expanded not.
	
	self shapeGroup applicationItem page refreshItem: self shapeGroup applicationItem.
"	self shapeGroup applicationItem page notifyPresenterResized "
]

{ #category : #accessing }
DrsLabel >> text [
	
	^ text
]

{ #category : #accessing }
DrsLabel >> text: aText [

	text := aText.
	self resetCaches.

	self hasAssignedExtent ifTrue: [ 
		self adaptShapeExtents ].

]

{ #category : #accessing }
DrsLabel >> textRepresentation [ 

	^ text asString
]

{ #category : #accessing }
DrsLabel >> toggleExpanded [ 

	expanded := expanded not.
	
	self shapeGroup applicationItem toggleLabelExpanded.

]

{ #category : #'selection highlights' }
DrsLabel >> topLeftPadding [

	^ 0@0
]

{ #category : #accessing }
DrsLabel >> topLeftPosition: aPoint [

	| extentToUse |
	
	extentToUse := self visibleExtent.
	
	compositeShape position: (aPoint + extentToUse half).

	self placeHighlightShapesWith: extentToUse.
	
	storedTopLeftPosition := aPoint
]

{ #category : #'selection highlights' }
DrsLabel >> updateHighlightShapePositions [

	| canAddNext |
	
	self hasHighlights ifFalse: [ ^ self ].
	
	self removeHighlightShapesFromComposite.
	
	canAddNext := true.
		
	self highlightShapesDo: [ :aHighlightShape |
		canAddNext ifTrue: [ 
			canAddNext := self addRoassalShapeFor: aHighlightShape.  ] ].
		
	(compositeShape extent = (0@0)) ifTrue: [
		compositeShape adjustToChildren. ].

	self topLeftPosition: self pivotPosition.

]

{ #category : #'text extents' }
DrsLabel >> visibleExtent [ 

	self wrappingEnabled ifTrue: [ 
		^ labelExtent x @ (naturalHeight*self linesCount + self linesReduction )
		 ].

	^ self visibleWidth @ naturalHeight
]

{ #category : #accessing }
DrsLabel >> visibleLength [

	^ visibleLength ifNil: [ self text fullLength ]
]

{ #category : #accessing }
DrsLabel >> visibleLength: aNumber [
	
	self wrappingEnabled ifTrue: [ ^ self ].

	aNumber = visibleLength ifTrue: [ ^ self ].

	visibleLength := aNumber.

	labelChunks := self labelChunksFrom: text with: styleSheet length: aNumber
]

{ #category : #'text extents' }
DrsLabel >> visibleWidth [ 

	^ self isShrinked 
		ifFalse: [ self fullTextWidth  ]
		ifTrue: [ self shortenedWidthForLength: visibleLength ]
]

{ #category : #accessing }
DrsLabel >> wrappingEnabled [

	^ wrappingEnabled
]

{ #category : #accessing }
DrsLabel >> wrappingEnabled: anObject [

	wrappingEnabled := anObject.
	
	anObject ifTrue: [ self prepareAsMultiLine ]
]

{ #category : #accessing }
DrsLabel >> xPositionOf: aCharacterPosition [ 

	| aLineIndex lineStart charPositions |
	aLineIndex := self lineIndexForCharacter: aCharacterPosition.
	lineStart := self firstCharacterOfLine: aLineIndex.
	charPositions := self ensureCharacterPositions.
	^ (charPositions at: (aCharacterPosition min: charPositions size)) - (charPositions at: (lineStart min: charPositions size))
]

{ #category : #private }
DrsLabel >> yPosOf: lineIndex [ 

	lineIndex = 1 ifTrue: [ ^ 0 ].
	^ naturalHeight + ((lineIndex - 2) * naturalHeight * linesScaling).
]
