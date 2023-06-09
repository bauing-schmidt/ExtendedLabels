Class {
	#name : #CSSChildSelector,
	#superclass : #CSSRelationshipSelector,
	#category : #'HTML-CSS'
}

{ #category : #accessing }
CSSChildSelector class >> operator [

	^'>'
]

{ #category : #testing }
CSSChildSelector >> isChildSelector [

	^true
]

{ #category : #testing }
CSSChildSelector >> matches: aNode [

	| node |

	node := aNode.
	selectors reverseDo: [ :ea |
		node ifNil: [^false].
		(ea matches: node) ifFalse: [^false].
		node := node parent.
	].
	^true
]
