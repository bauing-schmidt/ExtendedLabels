Class {
	#name : #HtmlFORMNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-DOM'
}

{ #category : #'initialize-release' }
HtmlFORMNode >> addDefaultStyle [
	| styles |
	styles := Dictionary newFrom: {
		'display' -> 'block'.
	}.
	self addStyle: (CSSDefaultStyleRule fromDictionary: styles)
]

{ #category : #rendering }
HtmlFORMNode >> addToHtmlMorph: aHtmlBlockMorph [
	super addToHtmlMorph: aHtmlBlockMorph.
	
	associatedForm morph: htmlMorph.
	associatedForm reset
]

{ #category : #accessing }
HtmlFORMNode >> associatedForm [
	^ associatedForm
]

{ #category : #accessing }
HtmlFORMNode >> encoding [
	"encoding for posting"
	^self attributes at: 'enctype' ifAbsent: [nil].  
]

{ #category : #'initialize-release' }
HtmlFORMNode >> initialize [ 
	super initialize.
	associatedForm := FormInputSet forForm: self
]

{ #category : #accessing }
HtmlFORMNode >> method [
	"method to submit with"
	^self attributes at: 'method' ifAbsent: ['get']
]

{ #category : #accessing }
HtmlFORMNode >> tag [
	^ 'form'
]

{ #category : #accessing }
HtmlFORMNode >> url [
	"url to submit to"
	^self attributes at: 'action' ifAbsent: [nil].  
]
