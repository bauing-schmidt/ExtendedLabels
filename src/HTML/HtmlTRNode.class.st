Class {
	#name : #HtmlTRNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-DOM'
}

{ #category : #'initialize-release' }
HtmlTRNode >> addDefaultStyle [
	| styles |
	styles := Dictionary newFrom: {
		'display' -> 'table-row'.
	}.
	self addStyle: (CSSDefaultStyleRule fromDictionary: styles)
]

{ #category : #accessing }
HtmlTRNode >> endStyles: aFormatter [
	aFormatter ensureNewlines: 1
]

{ #category : #accessing }
HtmlTRNode >> tag [
	^ 'tr'
]
