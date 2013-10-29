<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0" name="main"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:cx="http://xmlcalabash.com/ns/extensions"
                xmlns:l="http://xproc.org/library">
<p:input port="source"/>
<p:input port="parameters" kind="parameter"/>

<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

<cx:java-properties name="props" href="../../calabash/resources/etc/version.properties"/>

<p:template name="templ">
  <p:input port="template">
    <p:inline exclude-inline-prefixes="c cx l">
      <wrapper xmlns="http://docbook.org/ns/docbook">
        <releaseinfo role="xml-calabash-version">{$ver}</releaseinfo>
        <pubdate>{current-date()}</pubdate>
      </wrapper>
    </p:inline>
  </p:input>
  <p:with-param name="ver"
                select="concat(c:param-set/c:param[@name='version.major']/@value,'.',
                               c:param-set/c:param[@name='version.minor']/@value,'.',
                               c:param-set/c:param[@name='version.release']/@value)"/>
</p:template>

<p:insert match="/db:book/db:info" position="last-child"
          xmlns:db="http://docbook.org/ns/docbook">
  <p:input port="source">
    <p:pipe step="main" port="source"/>
  </p:input>
  <p:input port="insertion" select="/*/*">
    <p:pipe step="templ" port="result"/>
  </p:input>
</p:insert>

<p:xinclude/>

<!-- write custom schema that includes p:* elements!
<p:validate-with-relax-ng>
  <p:input port="schema">
    <p:document href="/Volumes/Data/docbook/docbook/relaxng/schemas/docbook.rng"/>
  </p:input>
</p:validate-with-relax-ng>
-->

<p:xslt name="xslt">
  <p:input port="stylesheet">
    <p:document href="refhtml.xsl"/>
  </p:input>
  <p:with-param name="base.dir" select="'build/'"/>
</p:xslt>

<p:sink/>

<p:for-each>
  <p:iteration-source>
    <p:pipe step="xslt" port="secondary"/>
  </p:iteration-source>

<!--
  <cx:message>
    <p:with-option name="message" select="base-uri(/)"/>
  </cx:message>
-->

  <p:store method="xhtml" indent="true">
    <p:with-option name="href" select="base-uri(/)"/>
  </p:store>
</p:for-each>

</p:declare-step>