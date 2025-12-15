<template>
  <div>
    <h4 :style="{ color: '#2c3e50', margin: '20px 0 15px', fontSize: '16px' }">
      <i :class="`fas ${section.icon}`"></i> {{ section.title }}
    </h4>
    <div class="content-columns">
      <div
        v-for="(example, index) in section.examples"
        :key="index"
        class="content-column"
      >
        <div class="code-example">
          <div v-if="example.title" class="code-title">{{ example.title }}</div>
          <pre><code v-html="highlightCode(example.code)"></code></pre>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CodeExamples',
  props: {
    section: {
      type: Object,
      required: true
    }
  },
  methods: {
    highlightCode(code) {
      if (!code) return ''
      // 简单的代码高亮：注释行
      return code
        .replace(/\/\/.*$/gm, '<span class="comment">$&</span>')
        .replace(/#.*$/gm, '<span class="comment">$&</span>')
    }
  }
}
</script>

<style scoped>
.content-columns {
  display: flex;
  gap: 30px;
  margin-bottom: 25px;
}

.content-column {
  flex: 1;
}

.code-example {
  background: #2c3e50;
  color: #ecf0f1;
  border-radius: 8px;
  padding: 15px;
  font-family: 'Courier New', monospace;
  font-size: 13px;
  overflow-x: auto;
  margin: 15px 0;
  border-left: 5px solid #3498db;
}

.code-title {
  color: #ecf0f1;
  font-weight: bold;
  margin-bottom: 10px;
  font-size: 14px;
}

.code-example pre {
  margin: 0;
  white-space: pre-wrap;
  word-wrap: break-word;
}

.code-example code {
  font-family: 'Courier New', monospace;
}

.code-example :deep(.comment) {
  color: #7f8c8d;
  font-style: italic;
}

@media (max-width: 1024px) {
  .content-columns {
    flex-direction: column;
    gap: 20px;
  }
}
</style>

