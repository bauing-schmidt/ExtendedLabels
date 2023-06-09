Class {
	#name : #HtmlBIGNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-DOM'
}

{ #category : #'initialize-release' }
HtmlBIGNode >> addDefaultStyle [
	| styles |
	styles := Dictionary newFrom: {
		'font-size' -> 'larger'.
	}.
	self addStyle: (CSSDefaultStyleRule fromDictionary: styles)
]

{ #category : #accessing }
HtmlBIGNode >> tag [
	^ 'big'
]
