Class {
	#name : #DrsAlignment,
	#superclass : #Object,
	#classVars : [
		'Default'
	],
	#classInstVars : [
		'singleton'
	],
	#category : #'Roassal3-ExtendedLabels-Allignment'
}

{ #category : #accessing }
DrsAlignment class >> default [ 

	^ Default ifNil: [ Default := DrsAlignmentLeftCenter new ]
]

{ #category : #accessing }
DrsAlignment class >> new [

	^ singleton ifNil: [ singleton := super new ]
]

{ #category : #API }
DrsAlignment class >> styleKey [

	self subclassResponsibility 
]

{ #category : #API }
DrsAlignment >> align: aShape in: aRectangle [

	self subclassResponsibility
]
