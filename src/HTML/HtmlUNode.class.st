Class {
	#name : #HtmlUNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-DOM'
}

{ #category : #'initialize-release' }
HtmlUNode >> addDefaultStyle [
	| styles |
	styles := Dictionary newFrom: {
		'text-decoration' -> 'underline'.
	}.
	self addStyle: (CSSDefaultStyleRule fromDictionary: styles)
]

{ #category : #accessing }
HtmlUNode >> tag [
	^ 'u'
]
