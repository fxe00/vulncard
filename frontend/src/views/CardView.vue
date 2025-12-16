<template>
  <div class="card-view-container">
    <el-loading v-loading="loading" />
    <div v-if="!loading && card" class="vulnerability-card">
      <!-- 卡片头部 -->
      <div class="card-header">
        <div class="header-title">
          <h1>
            <i :class="`fas ${card.icon || 'fa-bug'}`"></i> {{ card.title }}
          </h1>
          <p>{{ card.description }}</p>
        </div>
        <div class="header-badges">
          <div v-if="card.cve" class="cve-badge">
            <i class="fas fa-bug"></i> {{ card.cve }}
          </div>
          <div class="severity-badge" :class="getThreatLevelClass(card.threat_level || card.severity_level)">
            <i class="fas fa-exclamation-triangle"></i> {{ card.severity }}
          </div>
          <div v-if="card.cvss_score" class="cvss-badge">
            <i class="fas fa-chart-line"></i> CVSS: {{ card.cvss_score.toFixed(1) }}
            <span v-if="card.threat_level" class="threat-level">{{ card.threat_level }}</span>
          </div>
        </div>
      </div>

      <!-- 卡片内容 -->
      <div class="card-content">
        <!-- 视角选择器 -->
        <div class="perspective-selector">
          <h3>视角选择</h3>
          <div class="perspective-options">
            <div
              v-for="perspective in card.perspectives"
              :key="perspective.id"
              :class="['perspective-option', { active: activePerspective === perspective.id }]"
              @click="switchPerspective(perspective.id)"
            >
              <div class="perspective-icon">
                <i :class="`fas ${perspective.icon}`"></i>
              </div>
              <span class="perspective-name">{{ perspective.name }}</span>
            </div>
          </div>
        </div>

        <!-- 视角详情 -->
        <div class="perspective-detail">
          <div
            v-for="perspective in card.perspectives"
            :key="perspective.id"
            :id="perspective.id"
            :class="['detail-content', { active: activePerspective === perspective.id }]"
          >
            <div class="perspective-header">
              <h2>
                <i :class="`fas ${perspective.icon}`"></i> {{ perspective.title }}
              </h2>
              <p class="perspective-description">{{ perspective.description }}</p>
            </div>

            <div class="detail-content-container">
              <!-- 列布局 -->
              <div v-if="perspective.content.columns" class="content-columns first-content">
                <div
                  v-for="(column, colIndex) in perspective.content.columns"
                  :key="colIndex"
                  class="content-column"
                >
                  <InfoBox
                    v-for="(box, boxIndex) in column.boxes"
                    :key="boxIndex"
                    :box="box"
                    :class="{ 'first-box': boxIndex === 0 && colIndex === 0 }"
                  />
                </div>
              </div>

              <!-- 区块内容 -->
              <div v-for="(section, sectionIndex) in perspective.content.sections" :key="sectionIndex" :class="{ 'first-section': sectionIndex === 0 && !perspective.content.columns }">
                <!-- 攻击流程 -->
                <AttackFlow v-if="section.type === 'attack_flow'" :section="section" />

                <!-- 影响项 -->
                <ImpactSection v-if="section.type === 'impact'" :section="section" />

                <!-- 代码示例 -->
                <CodeExamples v-if="section.type === 'code_examples'" :section="section" />

                <!-- 表格 -->
                <InfoTable v-if="section.type === 'table'" :section="section" />

                <!-- 信息框区块 -->
                <InfoSection v-if="section.type === 'info'" :section="section" />
              </div>

              <!-- 页脚 -->
              <div v-if="card.footer_note" class="footer-note">
                <p>
                  <i class="fas fa-exclamation-triangle"></i> {{ card.footer_note }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <el-empty v-if="!loading && !card" description="未找到漏洞卡片" />
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import InfoBox from '../components/InfoBox.vue'
import AttackFlow from '../components/AttackFlow.vue'
import ImpactSection from '../components/ImpactSection.vue'
import CodeExamples from '../components/CodeExamples.vue'
import InfoTable from '../components/InfoTable.vue'
import InfoSection from '../components/InfoSection.vue'
import { ElMessage } from 'element-plus'

export default {
  name: 'CardView',
  components: {
    InfoBox,
    AttackFlow,
    ImpactSection,
    CodeExamples,
    InfoTable,
    InfoSection
  },
  setup() {
    const route = useRoute()
    const router = useRouter()
    const card = ref(null)
    const loading = ref(false)
    const activePerspective = ref('overview')

    const loadCard = async () => {
      loading.value = true
      try {
        const response = await axios.get(`/api/vulnerabilities/${route.params.id}`)
        card.value = response.data
        
        // 如果有补充信息，添加补充信息视角
        if (card.value.additional_info && hasAdditionalInfo(card.value.additional_info)) {
          const additionalPerspective = {
            id: 'additional',
            name: '补充信息',
            icon: 'fa-info-circle',
            title: '补充信息',
            description: 'CVE 链接、FOFA 语法、POC 和工具资源',
            content: {
              columns: [],
              sections: []
            }
          }
          
          // 构建补充信息内容
          const sections = []
          
          if (card.value.additional_info.cve_url) {
            sections.push({
              type: 'info',
              title: 'CVE 官方链接',
              icon: 'fa-link',
              border_color: 'green',
              columns: [{
                title: '',
                content: `<a href="${card.value.additional_info.cve_url}" target="_blank" style="color: #3498db; text-decoration: none; word-break: break-all;">${card.value.additional_info.cve_url} <i class="fas fa-external-link-alt" style="font-size: 12px; margin-left: 5px;"></i></a>`
              }]
            })
          }
          
          if (card.value.additional_info.fofa_query) {
            sections.push({
              type: 'info',
              title: 'FOFA 测绘语法',
              icon: 'fa-search',
              border_color: 'blue',
              columns: [{
                title: '',
                content: `<div style="background: #f4f4f4; padding: 12px; border-radius: 5px; font-family: 'Courier New', monospace; font-size: 13px; word-break: break-all;">${card.value.additional_info.fofa_query}</div>`
              }]
            })
          }
          
          if (card.value.additional_info.pocs && card.value.additional_info.pocs.length > 0) {
            const pocItems = card.value.additional_info.pocs.map(poc => {
              let item = `<a href="${poc.url}" target="_blank" style="color: #3498db; text-decoration: none; font-weight: 500;">${poc.name} <i class="fas fa-external-link-alt" style="font-size: 11px; margin-left: 4px;"></i></a>`
              if (poc.description) {
                item += `<div style="color: #666; font-size: 12px; margin-top: 4px; margin-left: 0;">${poc.description}</div>`
              }
              return item
            })
            sections.push({
              type: 'info',
              title: '公开 POC',
              icon: 'fa-code',
              border_color: 'purple',
              columns: [{
                title: '',
                content: {
                  type: 'list',
                  items: pocItems
                }
              }]
            })
          }
          
          if (card.value.additional_info.tools && card.value.additional_info.tools.length > 0) {
            const toolItems = card.value.additional_info.tools.map(tool => {
              let item = `<a href="${tool.url}" target="_blank" style="color: #3498db; text-decoration: none; font-weight: 500;">${tool.name} <i class="fas fa-external-link-alt" style="font-size: 11px; margin-left: 4px;"></i></a>`
              if (tool.description) {
                item += `<div style="color: #666; font-size: 12px; margin-top: 4px; margin-left: 0;">${tool.description}</div>`
              }
              return item
            })
            sections.push({
              type: 'info',
              title: '相关工具',
              icon: 'fa-tools',
              border_color: 'blue',
              columns: [{
                title: '',
                content: {
                  type: 'list',
                  items: toolItems
                }
              }]
            })
          }
          
          additionalPerspective.content.sections = sections
          card.value.perspectives.push(additionalPerspective)
        }
        
        if (card.value.perspectives && card.value.perspectives.length > 0) {
          activePerspective.value = card.value.perspectives[0].id
        }
      } catch (error) {
        console.error('加载卡片失败:', error)
        ElMessage.error('加载卡片失败')
      } finally {
        loading.value = false
      }
    }
    
    const hasAdditionalInfo = (info) => {
      return !!(info.cve_url || info.fofa_query || 
               (info.pocs && info.pocs.length > 0) || 
               (info.tools && info.tools.length > 0))
    }

    const switchPerspective = (id) => {
      activePerspective.value = id
    }

    const getThreatLevelClass = (level) => {
      const levelMap = {
        'critical': 'threat-critical',
        'high': 'threat-high',
        'medium': 'threat-medium',
        'low': 'threat-low',
        '严重': 'threat-critical',
        '高危': 'threat-high',
        '中危': 'threat-medium',
        '低危': 'threat-low'
      }
      return levelMap[level] || 'threat-high'
    }

    onMounted(() => {
      loadCard()
    })

    return {
      card,
      loading,
      activePerspective,
      switchPerspective,
      getThreatLevelClass,
      hasAdditionalInfo
    }
  }
}
</script>

<style scoped>
.card-view-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  padding: 20px;
  color: #333;
}

.vulnerability-card {
  width: 1100px;
  max-width: 95%;
  height: 700px;
  background: white;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
  display: flex;
  flex-direction: column;
}

.card-header {
  background: linear-gradient(to right, #e74c3c, #c0392b);
  color: white;
  padding: 20px 30px;
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  flex-shrink: 0;
  gap: 15px;
}

.header-title {
  flex: 1;
  min-width: 0;
  padding-right: 15px;
}

.card-header h1 {
  font-size: 24px;
  margin-bottom: 5px;
  letter-spacing: 0.5px;
  line-height: 1.4;
  word-break: keep-all;
  overflow-wrap: anywhere;
  white-space: normal;
  hyphens: none;
}

.card-header p {
  font-size: 14px;
  opacity: 0.9;
}

.header-badges {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
  flex-shrink: 0;
  min-width: fit-content;
  align-self: flex-start;
  margin-top: 2px;
}

.cve-badge {
  background: rgba(0, 0, 0, 0.2);
  padding: 8px 16px;
  border-radius: 20px;
  font-weight: bold;
  font-size: 13px;
  display: flex;
  align-items: center;
  font-family: 'Courier New', monospace;
}

.cve-badge i {
  margin-right: 6px;
}

.severity-badge {
  background: rgba(0, 0, 0, 0.2);
  padding: 8px 16px;
  border-radius: 20px;
  font-weight: bold;
  font-size: 14px;
  display: flex;
  align-items: center;
}

.severity-badge.threat-critical {
  background: rgba(139, 0, 0, 0.4);
  border: 1px solid rgba(255, 0, 0, 0.5);
}

.severity-badge.threat-high {
  background: rgba(184, 0, 0, 0.4);
  border: 1px solid rgba(255, 69, 0, 0.5);
}

.severity-badge.threat-medium {
  background: rgba(255, 140, 0, 0.4);
  border: 1px solid rgba(255, 165, 0, 0.5);
}

.severity-badge.threat-low {
  background: rgba(0, 100, 0, 0.4);
  border: 1px solid rgba(144, 238, 144, 0.5);
}

.severity-badge i {
  margin-right: 8px;
}

.cvss-badge {
  background: rgba(0, 0, 0, 0.2);
  padding: 8px 16px;
  border-radius: 20px;
  font-weight: bold;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 8px;
}

.cvss-badge i {
  margin-right: 4px;
}

.cvss-badge .threat-level {
  margin-left: 6px;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 11px;
  background: rgba(255, 255, 255, 0.2);
}

.card-content {
  display: flex;
  flex: 1;
  overflow: hidden;
}

.perspective-selector {
  width: 180px;
  background: #f8f9fa;
  border-right: 1px solid #eaeaea;
  display: flex;
  flex-direction: column;
  overflow-y: auto;
  flex-shrink: 0;
}

.perspective-selector h3 {
  color: #2c3e50;
  padding: 20px 15px 15px;
  font-size: 16px;
  border-bottom: 1px solid #e0e0e0;
  margin-bottom: 5px;
  position: sticky;
  top: 0;
  background: #f8f9fa;
  z-index: 10;
}

.perspective-options {
  flex: 1;
}

.perspective-option {
  padding: 16px 15px;
  cursor: pointer;
  display: flex;
  align-items: center;
  transition: all 0.3s;
  border-left: 4px solid transparent;
  margin-bottom: 2px;
}

.perspective-option:hover {
  background: rgba(231, 76, 60, 0.1);
}

.perspective-option.active {
  background: rgba(231, 76, 60, 0.15);
  border-left: 4px solid #e74c3c;
  color: #c0392b;
  font-weight: 600;
}

.perspective-icon {
  width: 28px;
  height: 28px;
  background: #e74c3c;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12px;
  font-size: 13px;
  flex-shrink: 0;
}

.perspective-name {
  font-size: 14px;
  line-height: 1.3;
}

.perspective-detail {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.perspective-header {
  padding: 20px 30px 15px;
  border-bottom: 1px solid #eee;
  flex-shrink: 0;
}

.perspective-header h2 {
  color: #2c3e50;
  font-size: 22px;
  display: flex;
  align-items: center;
}

.perspective-header h2 i {
  margin-right: 10px;
  color: #e74c3c;
}

.perspective-description {
  color: #666;
  font-size: 14px;
  margin-top: 5px;
}

.detail-content-container {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 0 30px 30px;
  min-height: 0;
  max-height: 100%;
}

/* 为第一个内容元素添加顶部间距，与补充信息视角保持一致 */
.detail-content-container > .content-columns.first-content {
  margin-top: 25px;
}

.detail-content-container > .content-columns.first-content > .content-column:first-child > .info-box.first-box {
  margin-top: 0;
}

/* 第一个 section（如攻击流程、影响项等）添加顶部间距 */
.detail-content-container > div.first-section {
  margin-top: 25px;
}

/* 调整第一个 section 内部 h4 的 margin-top，确保总间距为 25px */
.detail-content-container > div.first-section > div > h4 {
  margin-top: 0 !important;
}

.detail-content-container::-webkit-scrollbar {
  width: 8px;
}

.detail-content-container::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

.detail-content-container::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 4px;
}

.detail-content-container::-webkit-scrollbar-thumb:hover {
  background: #555;
}

.detail-content {
  display: none;
  animation: fadeIn 0.5s ease;
  padding-top: 20px;
  min-height: 100%;
}

.detail-content.active {
  display: block;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.content-columns {
  display: flex;
  gap: 30px;
  margin-bottom: 25px;
}

.content-column {
  flex: 1;
  min-width: 0;
}

.footer-note {
  margin-top: 25px;
  padding: 15px 30px;
  border-top: 1px solid #eee;
  font-size: 12px;
  color: #7f8c8d;
  text-align: center;
  flex-shrink: 0;
  background: #fafafa;
}

@media (max-width: 1200px) {
  .card-header h1 {
    font-size: 22px;
  }
}

@media (max-width: 1024px) {
  .vulnerability-card {
    height: auto;
    max-height: 90vh;
    min-height: 600px;
  }
  
  .card-header {
    flex-wrap: wrap;
  }
  
  .header-title {
    flex: 1 1 100%;
    padding-right: 0;
  }
  
  .header-badges {
    flex: 1 1 auto;
    justify-content: flex-end;
  }

  .card-content {
    flex-direction: column;
  }

  .perspective-selector {
    width: 100%;
    flex-direction: row;
    border-right: none;
    border-bottom: 1px solid #eaeaea;
    overflow-x: auto;
    overflow-y: hidden;
    flex-shrink: 0;
  }

  .perspective-selector h3 {
    display: none;
  }

  .perspective-options {
    display: flex;
    width: 100%;
  }

  .perspective-option {
    flex: 1;
    min-width: 150px;
    justify-content: center;
    text-align: center;
    flex-direction: column;
    padding: 15px 10px;
  }

  .perspective-icon {
    margin-right: 0;
    margin-bottom: 8px;
  }

  .content-columns {
    flex-direction: column;
    gap: 20px;
  }
}

@media (max-width: 768px) {
  .card-view-container {
    padding: 10px;
    align-items: flex-start;
  }

  .vulnerability-card {
    height: auto;
    max-height: calc(100vh - 20px);
    min-height: 500px;
  }

  .card-header {
    flex-direction: column;
    text-align: center;
    padding: 15px 20px;
    align-items: center;
  }

  .header-title {
    padding-right: 0;
    width: 100%;
  }

  .card-header h1 {
    font-size: 20px;
  }

  .header-badges {
    justify-content: center;
    width: 100%;
    margin-top: 10px;
  }

  .severity-badge,
  .cve-badge,
  .cvss-badge {
    margin: 0;
    font-size: 12px;
    padding: 6px 12px;
  }

  .detail-content-container {
    padding: 0 15px 20px;
  }

  .perspective-header {
    padding: 15px 20px 10px;
  }

  .perspective-header h2 {
    font-size: 18px;
  }
}
</style>

