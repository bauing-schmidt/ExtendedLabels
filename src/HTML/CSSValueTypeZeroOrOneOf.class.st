Class {
	#name : #CSSValueTypeZeroOrOneOf,
	#superclass : #CSSValueTypeConstraint,
	#category : #'HTML-CSS'
}

{ #category : #accessing }
CSSValueTypeZeroOrOneOf class >> type [

	^$?
]

{ #category : #testing }
CSSValueTypeZeroOrOneOf >> addValues: aCollection fromStream: in [

	| pos |
	pos := in position.
	(type addValues: aCollection fromStream: in) ifFalse:[in position: pos].
	^true
]
