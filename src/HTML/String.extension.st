Extension { #name : #String }

{ #category : #'*html' }
String >> asUnHtml [
	"Strip out all Html stuff (commands in angle brackets <>) and convert
the characters &<> back to their real value.  Leave actual cr and tab as
they were in text."
	| in out char rest |
	in := ReadStream on: self.
	out := WriteStream on: (String new: self size).
	[in atEnd] whileFalse:
		[in peek = $<
			ifTrue: [in unCommand] 	"Absorb <...><...>"
			ifFalse: [(char := in next) = $&
						ifTrue: [rest := in upTo: $;.
								out nextPutAll: (HtmlEntities all
									at: rest
									ifAbsent: [
										(rest beginsWith: '#')
											ifTrue: [
												rest second asLowercase = $x ifTrue: 
													[rest := '#16r', rest allButFirst allButFirst].
												Character value: rest allButFirst asNumber]
											ifFalse: [
												in last = $;
													ifTrue: ['&', rest, ';']
													ifFalse: ['&', rest]
													]]) asString]
						ifFalse: [out nextPut: char]].
		].
	^ out contents
]

{ #category : #'*html' }
String >> content [

	^self
]

{ #category : #'*html' }
String >> splitStringOn: aString [

	| idx lastIdx |
	idx := lastIdx := 1.

	^Array streamContents: 
	[:s |
		[idx <= self size] whileTrue:
		[
			idx := self findString: aString startingAt: lastIdx.
			idx = 0 ifTrue: [idx := self size + 1].
			s nextPut: (self copyFrom: lastIdx to: idx-1).
			lastIdx := idx + aString size.
		]
	]

]

{ #category : #'*html' }
String >> trimBoth [
	"Trim separators from both sides of the receiving string."
	
	^ self trimBoth: [ :char | char isSeparator ]
]

{ #category : #'*html' }
String >> trimBoth: aBlock [
	"Trim characters satisfying the condition given in aBlock from both sides of the receiving string."

	^ self trimLeft: aBlock right: aBlock
]

{ #category : #'*html' }
String >> trimLeft: aLeftBlock right: aRightBlock [
	"Trim characters satisfying the condition given in aLeftBlock from the left side and aRightBlock from the right sides of the receiving string."

	| left right |
	left := 1.
	right := self size.
	[ left <= right and: [ aLeftBlock value: (self at: left) ] ]
		whileTrue: [ left := left + 1 ].
	[ left <= right and: [ aRightBlock value: (self at: right) ] ]
		whileTrue: [ right := right - 1 ].
	^ self copyFrom: left to: right
]

{ #category : #'*html' }
String >> unquoted [

	^self withoutQuoting
]
