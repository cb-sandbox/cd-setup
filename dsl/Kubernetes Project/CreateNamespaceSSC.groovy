project "Kubernetes", {
      procedure "Create Namespace", {
            formalParameter "namespace", required: true
			step "Create Namespace with EC-Kubectl",
				resourceName: "k8s-agent",
				subproject: "/plugins/EC-Kubectl/project",
				subprocedure: "Create Or Update Objects",
				actualParameter: [
					config: "Kubectl",
					specSource: "fileContent",
					updateAction: "apply",
					fileContent: '''\
						apiVersion: v1
						kind: Namespace
						metadata:
						  name: $[namespace]
					'''.stripIndent()
				]
	}
	catalog 'Kubernetes', {
		iconUrl = null
		catalogItem 'Create Namespace', {
		description = '''\
			<xml>
				<title>

				</title>

				<htmlData>
				<![CDATA[

				]]>
				</htmlData>
			</xml>
		'''.stripIndent()
		buttonLabel = 'Create'
		iconUrl = 'logo-kubernetes.svg'
		subprocedure = 'Create Namespace'
		subproject = 'Kubernetes'
		useFormalParameter = '0'
		}
	}
}
