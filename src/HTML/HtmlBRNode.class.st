Class {
	#name : #HtmlBRNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-DOM'
}

{ #category : #rendering }
HtmlBRNode >> addToFormatter: formatter [
	formatter addChar: Character cr.
]

{ #category : #accessing }
HtmlBRNode >> tag [
	^ 'br'
]
