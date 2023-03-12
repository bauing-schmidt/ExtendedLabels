Class {
	#name : #DrsCursorInfo,
	#superclass : #Object,
	#instVars : [
		'enabled',
		'position',
		'color',
		'width',
		'cursorShape'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #accessing }
DrsCursorInfo >> color [

	^ color
]

{ #category : #accessing }
DrsCursorInfo >> color: anObject [

	color := anObject
]

{ #category : #accessing }
DrsCursorInfo >> cursorShape [

	^ cursorShape
]

{ #category : #accessing }
DrsCursorInfo >> cursorShape: anObject [

	cursorShape := anObject
]

{ #category : #accessing }
DrsCursorInfo >> enabled [

	^ enabled
]

{ #category : #accessing }
DrsCursorInfo >> enabled: anObject [

	enabled := anObject
]

{ #category : #initialization }
DrsCursorInfo >> initialize [ 

	super initialize.
	enabled := false.
	position := 0.
	width := 2.
	color := Color black alpha: 0.3.
]

{ #category : #accessing }
DrsCursorInfo >> position [

	^ position
]

{ #category : #accessing }
DrsCursorInfo >> position: anObject [

	position := anObject
]

{ #category : #accessing }
DrsCursorInfo >> width [

	^ width
]

{ #category : #accessing }
DrsCursorInfo >> width: anObject [

	width := anObject
]
