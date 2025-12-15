<template>
  <div class="info-box" style="margin-top: 25px;">
    <h4>
      <i :class="`fas ${section.icon}`"></i> {{ section.title }}
    </h4>
    <table class="example-table">
      <thead>
        <tr>
          <th v-for="(header, index) in section.headers" :key="index">{{ header }}</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(row, rowIndex) in section.rows" :key="rowIndex">
          <td v-for="(cell, cellIndex) in row" :key="cellIndex" v-html="formatCell(cell, cellIndex)"></td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'InfoTable',
  props: {
    section: {
      type: Object,
      required: true
    }
  },
  methods: {
    formatCell(cell, cellIndex) {
      if (typeof cell !== 'string') return cell
      
      // 根据内容判断是否需要特殊样式
      if (cell === '存在漏洞' || cell === '存在时间盲注') {
        return `<span style="color: #e74c3c; font-weight: bold;">${cell}</span>`
      } else if (cell === '正常') {
        return `<span style="color: #27ae60; font-weight: bold;">${cell}</span>`
      } else if (cell === '容易') {
        return `<span style="color: #27ae60; font-weight: bold;">${cell}</span>`
      } else if (cell === '中等') {
        return `<span style="color: #e67e22; font-weight: bold;">${cell}</span>`
      } else if (cell === '困难') {
        return `<span style="color: #e74c3c; font-weight: bold;">${cell}</span>`
      }
      
      return cell
    }
  }
}
</script>

<style scoped>
.example-table {
  width: 100%;
  border-collapse: collapse;
  margin: 15px 0;
  font-size: 13px;
}

.example-table th,
.example-table td {
  border: 1px solid #ddd;
  padding: 10px;
  text-align: left;
}

.example-table th {
  background-color: #f2f2f2;
  font-weight: bold;
  font-size: 13px;
}

.example-table tr:nth-child(even) {
  background-color: #f9f9f9;
}
</style>

