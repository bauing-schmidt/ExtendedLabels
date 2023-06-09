Class {
	#name : #CSSRule,
	#superclass : #CSSElement,
	#instVars : [
		'media'
	],
	#category : #'HTML-CSS'
}

{ #category : #testing }
CSSRule >> isAtImportRule [

	^false
]

{ #category : #testing }
CSSRule >> isStyleRule [

	^false
]

{ #category : #accessing }
CSSRule >> media [
	"Answer the value of media"

	^ media
]

{ #category : #accessing }
CSSRule >> media: anObject [
	"Set the value of media"

	media := anObject
]
