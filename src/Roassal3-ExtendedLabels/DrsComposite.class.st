Class {
	#name : #DrsComposite,
	#superclass : #RSComposite,
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #accessing }
DrsComposite >> addShape: aShape before: otherShape [ 
	"Add a shape in a composite shape"
	aShape addedIn: self.
	self children
		remove: aShape ifAbsent: [];
		add: aShape before: otherShape
]

{ #category : #accessing }
DrsComposite >> adjustToChildrenRelatively [

	"assuming that the children have position relative to the 0@0 of the composite coordinate system.
	It will shift all of them to spread them symetrically around the composite center. The composite
	itself is not shifted. "

	| rect delta |
	children ifNil: [ ^ self ].
	rect := children encompassingRectangle.
	delta := rect floatCenter negated.
	
	children do: [ :s | s basicTranslateBy: delta ].
	self 
		extent: rect extent.
]

{ #category : #accessing }
DrsComposite >> roassalPositionOffset [

    ^ self extent half
]

{ #category : #accessing }
DrsComposite >> roassalShape [

    ^ self
]

{ #category : #accessing }
DrsComposite >> widthDifference [

	^ 0@0
]
