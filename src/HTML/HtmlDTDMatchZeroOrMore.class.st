Class {
	#name : #HtmlDTDMatchZeroOrMore,
	#superclass : #HtmlDTDMatchConstraint,
	#category : #'HTML-Validator'
}

{ #category : #printing }
HtmlDTDMatchZeroOrMore >> printOn: aStream [

	expression printOn: aStream.
	aStream nextPut: $*

	
]

{ #category : #matching }
HtmlDTDMatchZeroOrMore >> validateChildren: aStream ofNode: aNode [

	[expression validateChildren: aStream ofNode: aNode] whileTrue:[].
	^true
]
