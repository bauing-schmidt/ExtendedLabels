Class {
	#name : #HtmlSTRONGNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-DOM'
}

{ #category : #'initialize-release' }
HtmlSTRONGNode >> addDefaultStyle [
	| styles |
	styles := Dictionary newFrom: {
		'font-weight' -> 'bold'.
	}.
	self addStyle: (CSSDefaultStyleRule fromDictionary: styles)
]

{ #category : #accessing }
HtmlSTRONGNode >> tag [
	^ 'strong'
]
