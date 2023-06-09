Class {
	#name : #HtmlBNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-DOM'
}

{ #category : #'initialize-release' }
HtmlBNode >> addDefaultStyle [
	| styles |
	styles := Dictionary newFrom: {
		'font-weight' -> 'bold'.
	}.
	self addStyle: (CSSDefaultStyleRule fromDictionary: styles)
]

{ #category : #accessing }
HtmlBNode >> tag [
	^ 'b'
]
