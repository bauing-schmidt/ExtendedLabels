Class {
	#name : #HtmlTagMissingEndError,
	#superclass : #HtmlTagStructureError,
	#category : #'HTML-DOM-Errors'
}

{ #category : #testing }
HtmlTagMissingEndError >> isStructuralError [

	^true
]

{ #category : #testing }
HtmlTagMissingEndError >> printOn: aStream [

	aStream nextPutAll: 'No closing tag found for tag: '.
	self parent tag printOn: aStream.
	
]

{ #category : #testing }
HtmlTagMissingEndError >> uniqueId [

	^self parent uniqueId, '-end-missing'
]
