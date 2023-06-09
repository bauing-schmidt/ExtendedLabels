Class {
	#name : #HtmlFRAMENode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-DOM'
}

{ #category : #rendering }
HtmlFRAMENode >> addToFormatter: formatter [
	| src |
	src := self attributes at: 'src' ifAbsent: [nil].
	formatter ensureNewlines: 1.
	src ifNotNil: [ formatter startLink: src ].
	formatter addString: 'frame '.
	formatter addString: (self name ifNil: ['(unnamed)']).
	src ifNotNil:  [ formatter endLink: src ].
	formatter ensureNewlines: 1.
]

{ #category : #accessing }
HtmlFRAMENode >> tag [
	^ 'frame'
]
