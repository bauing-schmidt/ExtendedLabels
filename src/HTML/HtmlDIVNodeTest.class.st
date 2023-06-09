Class {
	#name : #HtmlDIVNodeTest,
	#superclass : #TestCase,
	#instVars : [
		'divNode'
	],
	#category : #'HTML-Tests'
}

{ #category : #accessing }
HtmlDIVNodeTest >> divNode [

	^ divNode
]

{ #category : #accessing }
HtmlDIVNodeTest >> divNode: anObject [

	divNode := anObject
]

{ #category : #running }
HtmlDIVNodeTest >> setUp [ 
	self divNode: HtmlDIVNode new
]

{ #category : #testing }
HtmlDIVNodeTest >> test01DivShouldHaveDisplayBlockByDefault [

	self assert: self divNode boxType equals: #block
]
